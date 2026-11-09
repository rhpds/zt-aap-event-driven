# Event-Driven Ansible: From Event to Verified Outcome

## Overview

This Zero-Touch lab introduces Event-Driven Ansible (EDA) on Ansible Automation Platform 2.6, then hardens a single rulebook until it behaves like a production control path. Participants create one rulebook from scratch (source, condition, action), run it as a rulebook activation, secure intake with Event Streams, add environment and severity guardrails plus throttling, and finish with a closed-loop remediate → verify → escalate path. Events are Alertmanager-style HTTP alerts (lab injector or Alertmanager), not Splunk or Kafka. Success means a verified outcome and a clear Rule Audit trail—not merely that a job started.

## Target Audience

- **Role:** Platform engineers, SRE/Ops, and automation engineers new to Event-Driven Ansible
- **Experience level:** Beginner to intermediate
- **What they already know:** Basic Ansible playbooks; how to run a Job Template in AAP
- **What they don't know:** Rulebooks, activations, Event Streams, throttle/cooldown, closed-loop verify/escalate, using Rule Audit as decision evidence

## Prerequisites

- Comfortable reading YAML and running a Job Template in Ansible Automation Platform
- No prior Event-Driven Ansible experience required
- Lab validates progress with Zero-Touch solve/validate checks against platform state (activation, job counts, Rule Audit outcomes)—not against prior EDA knowledge

## Learning Objectives

1. Create a rulebook that defines a source, condition, and action for an alert-shaped event
2. Configure a rulebook activation on Ansible Automation Platform 2.6 so the rulebook listens continuously
3. Monitor matching events and actions in Rule Audit
4. Secure inbound events with Event Streams and verify that invalid credentials are rejected
5. Implement environment and severity conditions that skip noisy or out-of-scope alerts
6. Configure throttling so alert storms do not create uncontrolled job runs
7. Automate a remediate-then-verify response path from a matching alert
8. Verify that a failed verification triggers an escalation action
9. Analyze Rule Audit entries to explain skip, remediate, and escalate decisions

## Content Type

Lab (hands-on)

## Products & Technologies

- Red Hat Ansible Automation Platform 2.6 (Automation Controller and Event-Driven Ansible)
- Event Streams (authenticated event intake)
- Alertmanager-compatible HTTP alerts (lab event injector; optional Alertmanager container)
- Upstream/reference: ansible-rulebook concepts as implemented in AAP EDA

## Module Map

| Module | Title | Duration |
|--------|-------|----------|
| 1 | What EDA is (and isn't) | 25 min |
| 2 | Your first rulebook activation | 30 min |
| 3 | Event Streams: safe intake | 30 min |
| 4 | Guardrails: when not to act | 30 min |
| 5 | Verified outcome | 40 min |
| — | **Total hands-on** | **~2.5–3 hours** |
| — | Intro / wrap-up | ~20–30 min |
| — | **Total lab** | **~3–3.5 hours** |

Modules share one evolving rulebook artifact. Modules 1–2 teach the EDA model; Modules 3–5 harden the same rulebook into a production-grade path (Event Streams, conditions, throttle, closed-loop verify/escalate).

## Difficulty Level

Beginner (introduces EDA; finishes with intermediate guardrail and closed-loop patterns)

## Environment

**Learner view:** Pre-provisioned Ansible Automation Platform 2.6 with Controller and Event-Driven Ansible. Pre-built Job Templates for remediation, verification, and escalation. A target host or app that can be placed in a bad state and fixed. An alert injector that posts Alertmanager-shaped JSON (happy path, wrong env, low severity, storm/duplicates, verify-fail). Learners author and iteratively edit a single rulebook and configure one activation (plus Event Stream credentials).

**Automation needed:** Yes — bootstrap AAP objects (templates, credentials, inventories), target workload, event injector, and optional solve/validate scripts per module.

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

Zero-Touch solve/validate against observable platform state:

1. Simple match runs the expected Job Template (Modules 1–2)
2. Bad Event Stream token or wrong-env/low-severity alert does not remediate (Modules 3–4)
3. Alert storm produces job count within throttle policy (Module 4)
4. Happy path: remediate then verify success (Module 5)
5. Verify-fail path: escalation Job Template runs (Module 5)
6. Learner can map three Rule Audit entries to skip / remediate / escalate
