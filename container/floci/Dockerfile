FROM docker.io/floci/floci:2.5.0-compat

ENV FLOCI_STORAGE_MODE=persistent \
    FLOCI_STORAGE_SERVICES_S3_MODE=persistent \
    FLOCI_STORAGE_SERVICES_EC2_MODE=persistent \
    FLOCI_STORAGE_PERSISTENT_PATH=/app/data

COPY data/ /app/data/
RUN chmod -R a+rwX /app/data
