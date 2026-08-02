# Risks

| ID | Risk | Probability | Impact | Mitigation | Owner | Status |
|---|---|---|---|---|---|---|
| RISK-001 | 0/22 prayers have named cultural/theological sign-off. | certain | critical | Execute TF-001; named reviewer updates provenance and signs exact commit; require release gate green. | Product/content owner | open |
| RISK-002 | 20 provisional audio source files lack pronunciation/source approval. | low while excluded | critical if re-enabled | Target membership and catalog exclude them; re-enable only reviewed human audio. | Product/content owner | controlled |
| RISK-003 | VoiceOver order, contrast, iPad layout, and notification delivery are not manually verified. | high | high | Execute TF-007/TF-010 using the QA evidence template. | QA/release owner | open |
| RISK-004 | Public privacy URL, monitored beta feedback email, and support URL are absent. | certain | high | Execute TF-003; privacy/contact block external beta, support blocks later store submission. | Release owner | open |
| RISK-005 | Apple agreements, name availability, team/App ID ownership, and app record are unverified. | high | critical | Account Holder executes TF-002 before signed archive/upload. | Account holder | open |
| RISK-006 | SwiftData migration compatibility has no old-version fixture because no build has shipped. | medium after first beta | high | Capture the first shipped store fixture before model changes. | Engineering | monitored |
| RISK-007 | Religious-information distribution may have region-specific compliance fields, especially China mainland. | medium if broadly enabled | high | TF-002/AS-006 require account/legal region decision; do not enable China mainland by default. | Account/legal owner | open |
| RISK-008 | Store copy may imply audio even though v1 ships none. | high if stale copy reused | medium | TF-004/AS-005 use text-only copy; verify metadata against archive. | Product/release owner | controlled |
