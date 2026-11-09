# Module 02 — Event Streams: safe intake

### Brief Overview

Learners move from an open webhook-style intake to authenticated Event Streams on Ansible Automation Platform 2.6. They configure a stream, update the same evolving rulebook/activation path, prove a bad token is rejected, and confirm a valid token still delivers their track’s alert to a match.

### Audience and Time

- **Audience:** Same as Module 01; activation already running
- **Prerequisites:** Module 01 complete (track chosen, first match worked)
- **Duration:** ~25 minutes

### Learning Objectives

- Secure inbound events with Event Streams
- Verify that invalid credentials are rejected
- Confirm valid Event Stream credentials still match the chosen track’s alert

### Lab Structure

| Section | Title | Duration |
|---------|-------|----------|
| 1 | Shared: why Event Streams matter | 5 min |
| 2 | Create Event Stream and credentials | 8 min |
| 3 | Point rulebook/activation at Event Streams | 6 min |
| 4 | Track procedures: bad token vs good token inject | 6 min |

### Detailed Steps

1. Explain authenticated intake vs raw webhook in shared content.
2. Create an Event Stream in AAP EDA; record URL and token handling.
3. Update the rulebook source (or activation binding) to consume the Event Stream; restart/update activation as required.
4. Inject with an invalid token; observe rejection / no match.
5. **Track A/B/C:** Inject the track happy-path payload with a valid token; confirm Rule Audit match.
6. Checkpoint: bad token fails; good token matches for the chosen track.

### Key Takeaways

- Event Streams harden how events enter the platform
- The rulebook logic can stay the same when intake is secured
- Credential failures should be visible and expected in a negative test

### Infrastructure Notes

- Event Streams feature on AAP 2.6 EDA
- Injector must POST to the Event Stream endpoint from the Floci/lab network
