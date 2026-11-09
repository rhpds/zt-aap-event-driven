# Event-Driven Ansible: From Event to Verified Outcome

## Overview

This ~2 hour Zero-Touch lab introduces Event-Driven Ansible (EDA) on Ansible Automation Platform 2.6. Learners create one rulebook and harden it into a production-style path: activation, Event Streams, environment/severity guardrails, then remediate → verify against a Floci AWS emulator. At the start they pick one cloud track (S3 public exposure, open security group, or runaway instance) and follow that track’s procedures through every module; instructions for all three tracks are provided. Success is a verified cloud outcome and a clear Rule Audit trail—not merely that a job started.

## Target Audience

- **Role:** Platform engineers, SRE/Ops, and automation engineers new to Event-Driven Ansible
- **Experience level:** Beginner to intermediate
- **What they already know:** Basic Ansible playbooks; how to run a Job Template in AAP
- **What they don't know:** Rulebooks, activations, Event Streams, guardrails, closed-loop verify against cloud APIs, using Rule Audit as decision evidence

## Prerequisites

- Comfortable reading YAML and running a Job Template in Ansible Automation Platform
- No prior Event-Driven Ansible experience required
- Lab validates progress with Zero-Touch solve/validate checks against platform state for the learner’s chosen track

## Learning Objectives

1. Create a rulebook that defines a source, condition, and action for an alert-shaped event
2. Configure a rulebook activation on Ansible Automation Platform 2.6 so the rulebook listens continuously
3. Monitor matching events and actions in Rule Audit
4. Secure inbound events with Event Streams and verify that invalid credentials are rejected
5. Implement environment and severity conditions that skip noisy or out-of-scope alerts
6. Automate a remediate-then-verify response against Floci for the chosen cloud misconfiguration track
7. Analyze Rule Audit entries to explain skip versus remediate decisions

## Content Type

Lab (hands-on)

## Products & Technologies

- Red Hat Ansible Automation Platform 2.6 (Automation Controller and Event-Driven Ansible)
- Event Streams (authenticated event intake)
- Floci (AWS emulator on localhost-style endpoint :4566) as the cloud remediation sandbox
- Alertmanager-compatible HTTP alerts via lab event injector
- amazon.aws collection (Job Templates targeting Floci)

## Module Map

| Module | Title | Duration |
|--------|-------|----------|
| 1 | Pick your track + first match and activation | 35 min |
| 2 | Event Streams: safe intake | 25 min |
| 3 | Guardrails: when not to act | 25 min |
| 4 | Verified outcome on your Floci track | 35 min |
| — | **Total lab** | **~2 hours** |

**Tracks (choose one, instructions for all three in every module):**

| Track | Alert focus | Floci remediate / verify |
|-------|-------------|--------------------------|
| A — S3 | `S3PublicExposure` | Enable Block Public Access; verify BPA |
| B — Security group | `OpenSecurityGroup` | Quarantine / revoke wide ingress; verify rules |
| C — Runaway instance | `RunawayInstance` | Stop instance + quarantine tags; verify state/tags |

One evolving rulebook; Modules 1–3 teach the shared EDA spine (track-specific payloads/JTs); Module 4 closes the loop on the chosen Floci resource. Throttling and full escalate paths are stretch/callout only (not core graded for the 2-hour cut).

## Difficulty Level

Beginner (introduces EDA; finishes with intermediate guardrail and verify patterns)

## Environment

**Learner view:** Pre-provisioned AAP 2.6 (Controller + EDA). Pre-built remediate/verify/escalate Job Templates per track. Floci AWS emulator seeded with all three misconfigurations (learner remediates only their track). Alert injector with per-track payloads (happy path, wrong env, low severity). Learners pick a track once, edit one rulebook, configure one activation and Event Stream, and follow track-labeled procedures.

**Automation needed:** Yes — bootstrap AAP objects, Floci install/seed/reset, event injector, track marker for validate, solve/validate scripts.

## Infrastructure Requirements

- **Cloud provider:** TBD — confirmed in infrastructure phase
- **Cluster type:** TBD — confirmed in infrastructure phase
- **OCP version:** TBD — confirmed in infrastructure phase
- **Topology:** TBD — confirmed in infrastructure phase
- **Sizing:** TBD — confirmed in infrastructure phase
- **Automation approach:** Ansible (project.automation_type already set)
- **AI/MaaS:** TBD — confirmed in infrastructure phase
- **External services:** TBD — confirmed in infrastructure phase
- **AAP version:** 2.6
- **Non-GA products:** TBD — confirmed in infrastructure phase

## Assessment Strategy (Optional)

Zero-Touch solve/validate for the learner’s chosen track:

1. Track selected; simple match runs the track remediate JT (Module 1)
2. Bad Event Stream token rejected; valid token matches (Module 2)
3. Wrong-env or low-severity alert does not remediate (Module 3)
4. Prod/critical alert remediates in Floci and verify passes (Module 4)
5. Learner can point to Rule Audit for skip vs remediate
