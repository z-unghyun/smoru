# Stage 03 — HealthKit and Manual Fallback

## Goal

Add HealthKit permission flow and manual condition fallback without breaking the local app.

## Prompt for coding agent

Read the Agent Implementation Spec, PRD addendum, and SRD addendum first.

Implement HealthKit-related structure for SMORU.

Required work:

- HealthKit availability check
- HealthKit explanation screen connection
- permission request flow
- HealthKitManager protocol or service
- recent sleep summary fetch structure
- heart rate, HRV, respiratory rate, and step or active energy fetch structure
- missing-data handling
- denied-permission handling
- manual condition input route
- local DailySleepSummary generation from manual input

Important rules:

- Ask permission only after the explanation screen.
- If HealthKit is unavailable, denied, or empty, the app must still work.
- Manual input creates a local summary with source set to manual.
- Do not upload HealthKit source data to Firebase.
- Do not require Apple Watch.
- Do not use medical diagnosis wording.

Create this stage output:

- docs/agent_prompts/stage_outputs/03_healthkit_result.md

## Checks

Before committing, verify:

- HealthKit capability or setup instructions are documented.
- HealthKitManager exists.
- Permission state is represented in app state.
- Denied permission routes to manual input.
- Missing data routes to manual input.
- Manual condition input creates local summary data.
- App does not crash when HealthKit data is unavailable.
- Stage output file exists.

## Stop conditions

Stop and report failure if:

- App requires Apple Watch to continue.
- HealthKit permission denial blocks the whole app.
- HealthKit source data is prepared for server upload.
- Manual input is missing.
- No stage output was created.
