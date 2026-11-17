#!/usr/bin/env python3
"""Seed Floci with the lab bucket and the open security group.

Uses the AWS query and REST APIs with SigV4 so the setup runner does not need
the AWS CLI. Credentials are the Floci dummy pair, passed in by the playbook.
"""

import argparse
import datetime
import hashlib
import hmac
import json
import re
import sys
import urllib.error
import urllib.parse
import urllib.request


def sha256_hex(payload: bytes) -> str:
    return hashlib.sha256(payload).hexdigest()


def hmac_sha256(key: bytes, message: str) -> bytes:
    return hmac.new(key, message.encode("utf-8"), hashlib.sha256).digest()


def signing_key(secret_key: str, date_stamp: str, region: str, service: str) -> bytes:
    key = hmac_sha256(("AWS4" + secret_key).encode("utf-8"), date_stamp)
    key = hmac_sha256(key, region)
    key = hmac_sha256(key, service)
    return hmac_sha256(key, "aws4_request")


def signed_request(
    method: str,
    url: str,
    body: bytes,
    region: str,
    service: str,
    access_key: str,
    secret_key: str,
    content_type: str,
) -> tuple[int, bytes]:
    parsed = urllib.parse.urlsplit(url)
    canonical_uri = urllib.parse.quote(parsed.path if parsed.path else "/")
    amz_date = datetime.datetime.now(datetime.timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    date_stamp = amz_date[:8]
    payload_hash = sha256_hex(body)
    header_map = {
        "host": parsed.netloc,
        "x-amz-content-sha256": payload_hash,
        "x-amz-date": amz_date,
    }
    if content_type:
        header_map["content-type"] = content_type
    signed_names = sorted(header_map)
    canonical_headers = "".join(f"{name}:{header_map[name]}\n" for name in signed_names)
    canonical_request = "\n".join(
        [
            method,
            canonical_uri,
            parsed.query,
            canonical_headers,
            ";".join(signed_names),
            payload_hash,
        ]
    )
    credential_scope = f"{date_stamp}/{region}/{service}/aws4_request"
    string_to_sign = "\n".join(
        [
            "AWS4-HMAC-SHA256",
            amz_date,
            credential_scope,
            sha256_hex(canonical_request.encode("utf-8")),
        ]
    )
    signature = hmac.new(
        signing_key(secret_key, date_stamp, region, service),
        string_to_sign.encode("utf-8"),
        hashlib.sha256,
    ).hexdigest()
    headers = {
        "Authorization": (
            "AWS4-HMAC-SHA256 "
            f"Credential={access_key}/{credential_scope}, "
            f"SignedHeaders={';'.join(signed_names)}, "
            f"Signature={signature}"
        ),
        "x-amz-content-sha256": payload_hash,
        "x-amz-date": amz_date,
    }
    if content_type:
        headers["Content-Type"] = content_type
    request = urllib.request.Request(url, data=body, headers=headers, method=method)
    try:
        with urllib.request.urlopen(request, timeout=30) as response:
            return response.status, response.read()
    except urllib.error.HTTPError as error:
        return error.code, error.read()


def error_code(payload: bytes) -> str:
    match = re.search(br"<Code>([^<]+)</Code>", payload)
    if match is None:
        return ""
    return match.group(1).decode("utf-8")


def require_success(action: str, status: int, body: bytes, allowed_codes: set[str]) -> str:
    code = error_code(body)
    if status in (200, 204) or code in allowed_codes:
        return code
    snippet = body[:400].decode("utf-8", errors="replace")
    raise SystemExit(f"{action} failed status={status} code={code} body={snippet}")


def first_group_id(payload: bytes) -> str:
    match = re.search(br"<groupId>([^<]+)</groupId>", payload)
    if match is None:
        return ""
    return match.group(1).decode("utf-8")


def ec2_post(endpoint: str, region: str, access_key: str, secret_key: str, fields: dict[str, str]) -> tuple[int, bytes]:
    body = urllib.parse.urlencode(fields).encode("utf-8")
    return signed_request(
        "POST",
        endpoint.rstrip("/") + "/",
        body,
        region,
        "ec2",
        access_key,
        secret_key,
        "application/x-www-form-urlencoded",
    )


def seed(endpoint: str, bucket: str, security_group: str, region: str, access_key: str, secret_key: str) -> None:
    base = endpoint.rstrip("/")
    status, body = signed_request(
        "PUT",
        f"{base}/{bucket}",
        b"",
        region,
        "s3",
        access_key,
        secret_key,
        "",
    )
    require_success("CreateBucket", status, body, {"BucketAlreadyOwnedByYou", "BucketAlreadyExists"})
    status, body = ec2_post(
        base,
        region,
        access_key,
        secret_key,
        {
            "Action": "CreateSecurityGroup",
            "Version": "2016-11-15",
            "GroupName": security_group,
            "GroupDescription": "Intentionally open SG for EDA lab",
        },
    )
    code = require_success("CreateSecurityGroup", status, body, {"InvalidGroup.Duplicate"})
    group_id = first_group_id(body)
    if code == "InvalidGroup.Duplicate" or not group_id:
        status, body = ec2_post(
            base,
            region,
            access_key,
            secret_key,
            {
                "Action": "DescribeSecurityGroups",
                "Version": "2016-11-15",
                "GroupName.1": security_group,
            },
        )
        require_success("DescribeSecurityGroups", status, body, set())
        group_id = first_group_id(body)
    if not group_id:
        raise SystemExit(f"CreateSecurityGroup returned no group id for {security_group}")
    status, body = ec2_post(
        base,
        region,
        access_key,
        secret_key,
        {
            "Action": "AuthorizeSecurityGroupIngress",
            "Version": "2016-11-15",
            "GroupId": group_id,
            "IpPermissions.1.IpProtocol": "tcp",
            "IpPermissions.1.FromPort": "22",
            "IpPermissions.1.ToPort": "22",
            "IpPermissions.1.IpRanges.1.CidrIp": "0.0.0.0/0",
        },
    )
    require_success("AuthorizeSecurityGroupIngress", status, body, {"InvalidPermission.Duplicate"})


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--endpoint")
    parser.add_argument("--bucket")
    parser.add_argument("--security-group")
    parser.add_argument("--region")
    parser.add_argument("--access-key")
    parser.add_argument("--secret-key")
    return parser.parse_args(argv)


def main(argv: list[str]) -> None:
    args = parse_args(argv)
    values = {
        "endpoint": args.endpoint,
        "bucket": args.bucket,
        "security-group": args.security_group,
        "region": args.region,
        "access-key": args.access_key,
        "secret-key": args.secret_key,
    }
    missing = [name for name, value in values.items() if not value]
    if missing:
        raise SystemExit("Missing arguments: " + ", ".join(missing))
    seed(
        values["endpoint"],
        values["bucket"],
        values["security-group"],
        values["region"],
        values["access-key"],
        values["secret-key"],
    )
    print(json.dumps({"bucket": values["bucket"], "security_group": values["security-group"], "endpoint": values["endpoint"]}))


if __name__ == "__main__":
    main(sys.argv[1:])
