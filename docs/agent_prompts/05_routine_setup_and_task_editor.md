# Stage 05 — Routine Setup and Task Editor

## Goal

Implement routine template selection, routine setup, and task editing.

## Prompt for coding agent

Read the Agent Implementation Spec and native addenda first.

Build:

- routine template selection screen
- routine setup screen
- task add/edit screen or sheet
- mode behavior editor for 확장, 기본, 축소
- end-time based schedule preview
- sample templates

Required task types:

- basic
- alarm-like
- multi-timer
- app open
- link open

Rules:

- One routine has three mode variants.
- The user sets a routine end time.
- Start time is calculated backwards.
- 축소 keeps essentials and shortens the routine.
- Task mode action can be keep, replace, or skip.
- Do not build focus execution in this stage. That is stage 06.

Create this stage output:

- docs/agent_prompts/stage_outputs/05_routine_setup_result.md

## Checks

Verify:

- template selection exists
- setup screen can edit end time
- task editor can create at least basic/link/app-open task data
- each task has behavior for 확장, 기본, 축소
- schedule preview changes by mode
- 축소 preview is shorter than 기본 in sample data
- stage output exists

## Stop conditions

Stop if:

- routine modes are separate unrelated routines
- no end-time based scheduling exists
- 축소 does not shorten the routine
- no stage output is created
