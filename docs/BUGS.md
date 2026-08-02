# Bugs

| ID | Severity | Area | Summary | Status | Evidence |
|---|---|---|---|---|---|
| BUG-001 | high | Persistence | Disk-store fallback and SwiftData mutations previously failed silently. | fixed; verification pending | Release compile passed 2026-07-29; persistence UI test added. |
| BUG-002 | high | Reminders | Reminder preferences could be persisted before OS scheduling succeeded. | fixed; manual verification pending | `NotificationManager.schedule/sync` are async/throwing; UI updates after success. |
| BUG-003 | medium | Build harness | Default simulator `iPhone 15` was unavailable and the harness built only Debug. | fixed; verified | Script discovers an available iPhone and builds Release before tests. |
| BUG-004 | medium | Preferences | Script preference did not affect the Today card, so changing language/script appeared to do nothing there. | fixed; verification pending | `PrayerCardView` now receives `settings.scriptPreference` and renders through `PrayerTextView`; physical-device build/install/launch needed. |
| BUG-005 | medium | Audio | Local Debug builds could not preview repository audio because audio files were excluded and `Listen` only used catalog `audioAssetName` values. | superseded by consumer policy | Normal builds no longer expose unapproved preview audio; any future QA-only preview requires an explicit compilation condition. |
| BUG-006 | high | Audio/content integrity | Debug preview played `vishnu-narayana` for `vishnu-shantakaram` and `hanuman-namah` for `hanuman-manojavam`, so displayed sacred text and audio disagreed. Other candidates also lack heard transcripts/timing approval. | code fixed; listening verification pending | Exact-ID resolver and regression tests remove both substitutions; `Content/audio_candidate_manifest.csv` and `docs/AUDIO_LYRIC_ALIGNMENT_PLAN.md` retain remaining evidence gaps. |
| BUG-007 | medium | Audio UX | Listen was offered for all 22 prayers even when the current bundle had no exact approved recording. | code fixed; device verification pending | Today/onboarding/Me/player derive modes from approved current-bundle availability; unsupported Listen is omitted. |
| BUG-008 | high | Prayer session | Candidate song durations leaked into canonical text sessions, making Om Namo Narayanaya 113 seconds, Om Namah Shivaya 180 seconds, and other micro-prayers unexpectedly long. | fixed; content review pending | Nine durations restored from `Content/hero_prayers.md`; structural validation passes. |
| BUG-009 | high | Player UX | Chant was silently selected after unavailable Listen and Begin only started an unexplained timer; Silent was also undefined. | code fixed; device/usability verification pending | Persistent mode guidance, complete text/meaning, mode-specific controls/status, and explicit self-led completion added; controller/UI regressions pass. |
| BUG-010 | medium | Preferences | Script preference still did not update prayer rows in Moments or Saved. | fixed; UI verification pending | `PrayerRow` now renders Devanagari, IAST, or both from the shared live setting. |
| BUG-011 | medium | Reminders | Reminder times were fixed and could not be edited. | code fixed; physical delivery verification pending | Per-slot time persists in UserDefaults; locale-aware pickers atomically reschedule stable request IDs and roll back failure. |

No other reproducible code defects are currently open. Release risks and
unverified behavior are tracked separately in `docs/RISKS.md`.

Record observed behavior, reproduction steps, expected behavior, environment, and evidence. Do not convert assumptions into confirmed bugs.
