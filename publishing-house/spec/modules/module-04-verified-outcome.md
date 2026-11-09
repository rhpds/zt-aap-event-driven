# Module 04 — Verified outcome on your Floci track

### Brief Overview

Learners close the loop for their chosen cloud track: a matching alert remediates the misconfiguration in Floci, a verify Job Template confirms the fixed state, and Rule Audit is used to explain skip versus remediate decisions. Instructions for all three tracks are present; learners complete only their path.

### Audience and Time

- **Audience:** Learners finishing the 2-hour lab
- **Prerequisites:** Modules 01–03 complete; Floci still seeded for unused tracks (harmless)
- **Duration:** ~35 minutes

### Learning Objectives

- Automate a remediate-then-verify response against Floci for the chosen track
- Observe the corrected cloud resource state in Floci
- Analyze Rule Audit entries to explain skip versus remediate decisions

### Lab Structure

| Section | Title | Duration |
|---------|-------|----------|
| 1 | Shared: verified outcome vs fire-and-forget | 5 min |
| 2 | Wire verify (and optional escalate stretch) into the rulebook/workflow | 8 min |
| 3 | Track procedures: remediate + verify in Floci | 15 min |
| 4 | Rule Audit recap across skip and remediate | 7 min |

### Detailed Steps

1. Explain that success means the cloud state changed and was checked—not only that a job started.
2. Update the rulebook or Controller workflow so the track path runs remediate then verify.
3. **Track A — S3:** Inject `S3PublicExposure`; confirm BPA enabled in Floci; verify JT succeeds.
4. **Track B — SG:** Inject `OpenSecurityGroup`; confirm wide ingress removed/quarantined; verify JT succeeds.
5. **Track C — Instance:** Inject `RunawayInstance`; confirm stopped + quarantine tags; verify JT succeeds.
6. Review Rule Audit for at least one earlier skip (Module 03) and this remediate path.
7. Optional stretch: force verify-fail / run escalate JT (not required for core validate).
8. Checkpoint: chosen track remediated and verified in Floci; learner can narrate skip vs act from Rule Audit.

### Key Takeaways

- Closed-loop automation ends in a verified state
- Floci lets the lab teach real AWS-shaped APIs without a live account
- One EDA control path can serve multiple cloud use cases via track-specific actions
- Rule Audit is how you defend automation decisions

### Infrastructure Notes

- Floci must expose the APIs used by each track’s remediate/verify playbooks
- AAP credentials use Floci endpoint (`:4566`); execution nodes must route to Floci VM
- Reset/seed automation restores all three resources between sessions
