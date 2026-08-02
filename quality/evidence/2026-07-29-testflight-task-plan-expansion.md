# TestFlight Task-Plan Expansion Evidence

Date: 29 July 2026  
Scope: TF-001 through TF-012 documentation  
Lifecycle after work: `verification_pending`

## Result

Created 12 detailed task briefs under `docs/testflight-tasks/`, covering 84
individually identified subtasks.

Each task contains:

- task summary;
- expected change/outcome;
- what is being done;
- why it is required;
- how the task is executed;
- owner, dependency, blocking relationship, and evidence destination.

Each subtask contains:

- a description explicitly answering summary, what, why, expected change, and
  how;
- ordered executable procedure;
- objective Done criteria;
- required evidence;
- stop/escalation conditions preventing false completion.

## Execution safeguards added

- Human cultural/theological judgment cannot be completed by a model.
- Apple-account state cannot be inferred from repository settings.
- Private credentials, tester lists, phone numbers, and signing material stay
  outside Git.
- Dirty working trees must be reconciled without discarding unrelated user
  work.
- Build-number uniqueness must be checked in App Store Connect.
- Results must match exact Git SHA, version, build, destination, and artifact.
- Invalidated test runs and Apple failures remain evidence; gates may not be
  weakened.
- Binary changes return to TF-005; sacred-content changes return to TF-001.
- App Store Connect, Jira, and Notion remain copies of repository-owned truth.

## Coverage

| Task | Brief | Subtasks |
|---|---|---:|
| TF-001 | Named human prayer-content sign-off | 7 |
| TF-002 | Apple account, App ID, and app record | 7 |
| TF-003 | Public privacy URL and beta contacts | 6 |
| TF-004 | TestFlight metadata and review packet | 7 |
| TF-005 | Release-candidate and build identity freeze | 7 |
| TF-006 | Exact-commit automated release gate | 8 |
| TF-007 | Manual accessibility and device QA | 8 |
| TF-008 | Signed distribution archive | 7 |
| TF-009 | Upload, processing, and compliance | 7 |
| TF-010 | Internal TestFlight go/no-go | 7 |
| TF-011 | External Beta App Review | 6 |
| TF-012 | Controlled external beta and triage | 7 |
| **Total** | **12 briefs** | **84** |

## Verification

- Every `TF-001` through `TF-012` task has one detailed brief.
- Every subtask ID is unique and uses its parent task prefix.
- Every subtask has Description, Procedure, Done, Evidence, and Stop/Escalate
  sections.
- Every subtask Description explicitly includes summary, what/why, expected
  change, and how.
- Canonical backlog task-index links resolve to the detailed briefs.
- Local Markdown links, JSON parsing, and whitespace validation pass.

## Intentionally not performed

No task was represented as executed merely because its plan was written.
Content review, Apple account changes, URLs/contacts, candidate freeze, tests,
signed archive, upload, device QA, TestFlight review, and tester invitations
remain governed by their existing statuses and evidence requirements.
