# Stage 08 Acceptance Checks

Use this together with `stage_08.md`.

## Prompt addition

After reviewing all previous stage outputs, check the app against the V1 native contract.

Required checks:

- iOS project exists
- SwiftUI is used
- HealthKit flow exists
- manual fallback exists
- local models exist
- Home daily visual exists
- History monthly view exists
- routine setup exists
- three routine modes exist
- focus screen exists
- timed task advance exists
- local notification flow exists
- trial mode exists
- login structure exists
- backend config is example-only
- privacy screen exists

## Required result file

Create:

- docs/agent_prompts/stage_outputs/08_acceptance_checks_result.md

## Result format

Write:

- pass or fail
- implemented items
- missing items
- build steps
- test steps
- known limitations
- owner setup needed

## Stop conditions

Do not mark the project done if the app is not native iOS, if the focus screen is missing, or if the result file is missing.
