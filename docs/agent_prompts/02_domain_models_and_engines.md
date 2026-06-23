# Stage 02 — Domain Models and Engines

## Goal

Create the local domain layer before connecting external services.

## Prompt for coding agent

Read the Agent Implementation Spec and the native SRD addendum first.

Implement SwiftData models, value types, enums, and pure engines for SMORU.

Required areas:

- user settings
- daily sleep summary
- sleep condition score
- sleep fragment parameters
- routine template
- routine task
- routine mode variant
- routine session
- routine task record
- night checklist
- manual condition input

Required engines:

- sleep condition scoring
- sleep fragment parameter generation
- routine mode selection
- routine schedule calculation
- routine session state handling

Key rules:

- One routine has three modes: 확장, 기본, 축소.
- 축소 keeps essentials and shortens duration.
- The user sets a routine end time.
- Start time is calculated backwards from total duration.
- Sleep fragment parameters are deterministic for the same date.
- Use sample data only in this stage.

Create this stage output:

- docs/agent_prompts/stage_outputs/02_domain_models_result.md

## Checks

Before committing, verify:

- Domain models exist.
- Routine mode enum exists.
- Routine task type enum exists.
- Schedule engine calculates start and end times.
- 축소 sample plan is shorter than 기본 sample plan.
- Sleep fragment seed is stable for the same date.
- Domain logic is not buried inside SwiftUI views.
- Stage output file exists.

## Stop conditions

Stop and report failure if:

- Routine modes are unrelated routines.
- 축소 mode does not actually shorten the plan.
- Domain logic is only implemented in UI views.
- No stage output was created.
