# TestFlight Task Briefs

These files are the authoritative implementation plans for the task IDs in
`../TESTFLIGHT_READINESS_BACKLOG.md`.

- The backlog owns task order, dependency status, and overall release status.
- Each `TF-xxx.md` file owns that task's subtask IDs, implementation procedure,
  completion tests, evidence, and escalation boundaries.
- Jira and Notion may copy this content, but must not become the source of
  truth.

## Required execution behavior

Before starting a subtask, an implementer must:

1. read `AGENTS.md`, `.factory/AGENTS.factory.md`,
   `quality/quality-manifest.json`, the canonical backlog, and the complete task
   brief;
2. verify all dependencies and inputs named by the brief;
3. change the task status to `in_progress` only after work actually starts;
4. preserve real failures and never manufacture human/account/device evidence;
5. use the exact Done/Evidence criteria before reporting completion; and
6. update the repository first, then synchronize any Jira/Notion copy.

If a human, Apple account, private credential, legal judgment, or unavailable
device is required, the model prepares the handoff and stops at the stated
boundary. “Asked a human” is not the same as completing the subtask.

## Description contract

Every task and subtask description must concisely answer:

1. What is the summary?
2. What are we doing?
3. Why are we doing it?
4. What change or outcome do we expect?
5. How are we doing it?

The answers may be combined into prose and may appear in any order. `Procedure`
then provides the mechanical steps, while `Done when`, `Evidence`, and
`Stop/escalate` prevent ambiguous or false completion.

## Brief index

- `TF-001.md` — named human prayer-content sign-off
- `TF-002.md` — Apple account, App ID, and app record
- `TF-003.md` — public privacy URL and beta contacts
- `TF-004.md` — TestFlight metadata and review packet
- `TF-005.md` — release-candidate and build identity freeze
- `TF-006.md` — exact-commit automated release gate
- `TF-007.md` — manual accessibility and device QA
- `TF-008.md` — signed distribution archive
- `TF-009.md` — upload, processing, and compliance
- `TF-010.md` — internal TestFlight go/no-go
- `TF-011.md` — external Beta App Review
- `TF-012.md` — controlled external beta and triage
