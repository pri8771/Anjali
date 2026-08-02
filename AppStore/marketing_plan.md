# Anjali Marketing and Launch Plan

This plan must describe the product that actually ships. The repository is the
source of truth; no campaign may precede the gates in
`../docs/TESTFLIGHT_READINESS_BACKLOG.md`.

## Positioning

**A sacred pause, not a session.** Anjali offers one short Hindu prayer suited
to a selected moment and time of day. It is offline, accountless, private,
ungamified, and designed to be closed after the prayer.

Do not call it a feed, recommendation engine, meditation library, puja guide,
bhajan player, astrology app, or personalized service. Do not claim that audio,
remote sync, analytics, accounts, or an in-app feedback tool exist.

## Trust requirements before outreach

- TF-001 named human prayer review passes 22/22.
- Marketing copy is reviewed by the same content/cultural owner.
- The linked privacy policy and feedback/support contacts are live.
- Screenshots come from the approved build and contain only approved content.
- Testimonials have explicit permission and are quoted accurately.
- “Built with scholars/advisors” is used only if the named people actually
  participated and approved that characterization.

## Audiences

Initial outreach may include:

- Hindu practitioners seeking a brief daily ritual;
- diaspora and heritage learners who value Devanagari, transliteration, and a
  clear English meaning;
- busy or traveling practitioners who need offline use;
- VoiceOver/large-text users who can help validate accessibility;
- cultural advisors, temples, and community organizations willing to review
  the product rather than merely promote it.

No geographic or demographic percentage is asserted without research.

## Message pillars

1. **Respect:** traditional prayers with honest source notes and named human
   review.
2. **Simplicity:** one short prayer, no feed, streak pressure, or time-in-app
   incentive.
3. **Privacy:** no account, tracking, advertising, analytics, or network
   service in v1.
4. **Access:** iPhone/iPad, offline use, multiple script preferences, optional
   local reminders, VoiceOver/large-text support subject to final QA.

## Rollout

### Before external beta

- Complete TF-001–TF-010.
- Prepare the approved `testflight_metadata.md` packet.
- Invite cultural advisors and device/accessibility testers individually.
- Do not advertise public availability.

### Controlled external beta

- Begin with 20–30 email-invited testers after TF-011.
- Ask for cultural accuracy, clarity, accessibility, offline/reminder behavior,
  and defects using `beta_testing_plan.md`.
- Pause outreach on the stop conditions in TF-012.
- Expand only when the first cohort exits green and a larger cohort has a named
  testing objective.

### App Store launch

- Complete AS-001–AS-007, including screenshots and final storefront copy.
- Coordinate community/temple/cultural-center outreach only after App Review
  approval and release timing are known.
- Prefer an honest build story, cultural-review process, and privacy posture
  over claims about scale.

## Organic channels

- Direct community and cultural-organization outreach.
- Opt-in email to beta participants.
- Founder/team social accounts.
- Appropriate community forums after reading and following their rules.
- Editorial posts about offline-first design and the content-review process.
- Product-launch platforms only when the public App Store build is approved.

No paid advertising is planned for v1. Reconsidering that is a product decision,
not an engineering default.

## Measurement without product analytics

The shipping app intentionally has no analytics. Use only:

- App Store Connect/TestFlight aggregate information Apple makes available;
- number invited and installed where TestFlight exposes it;
- feedback emails/interviews and TestFlight feedback;
- crash diagnostics;
- App Store ratings/reviews after public release;
- outreach records maintained outside the product.

Do not publish download, retention, active-user, conversion, or rating targets
as measured commitments unless the owner defines an ethical measurement source.
Do not add tracking merely to populate a launch dashboard.

## Response and triage

- Review beta feedback/crash queues each business day during active testing.
- Acknowledge direct reports within two business days.
- Put canonical product defects/decisions in the repository first.
- Route prayer/cultural feedback to the named human content owner.
- Never promise a fix or release date before scope and verification are known.

## Success

Launch readiness is evidence-based:

- content, privacy, accessibility, device, and distribution gates pass;
- no open P0 or release-blocking P1 remains;
- public claims match the exact binary;
- cultural advisors and product/QA/release owners record go;
- early feedback shows the experience is respectful and understandable.
