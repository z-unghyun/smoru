# Stage 04 — Visual, Home, and History

## Goal

Build the core daily visual, Home, and History screens.

## Prompt for coding agent

Read the Agent Implementation Spec and native addenda first.

Build:

- daily visual SwiftUI view
- Home screen using today's visual
- History screen with monthly collection
- date detail route
- sample data for trial mode

Rules:

- The daily visual is one integrated organic object.
- It receives parameters from the domain engine.
- It changes by size, edge, color, glow, roundness, and clarity.
- It should render consistently for the same date and same values.

Create this stage output:

- docs/agent_prompts/stage_outputs/04_visual_result.md

## Checks

Verify:

- daily visual view exists
- Home displays it
- History displays multiple dates
- trial mode displays sample data
- stage output exists

## Stop conditions

Stop if the main visual is only a plain score card or if no stage output is created.
