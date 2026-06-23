# Stage 01 — Native iOS Project Skeleton

## Goal

Create only the native iOS project skeleton for SMORU.

## Prompt for coding agent

Read these files first:

- docs/AGENT_IMPLEMENTATION_SPEC.md
- docs/smoru_srd_v1_native_addendum.md

Implement a SwiftUI iOS 17+ project skeleton.

Required files or equivalent modules:

- SmoruApp.swift
- AppState.swift
- AppRouter.swift
- AppDependencyContainer.swift
- DesignSystem folder
- Features folder
- placeholder SwiftUI views for Entry, TrialHome, HealthKitIntro, ManualConditionInput, Home, SleepReport, RoutineTemplateSelection, RoutineSetup, RoutineFocus, History, Settings
- SwiftData container setup

Do not implement the whole app in this stage.

Do not create a web app.

Create this stage output:

- docs/agent_prompts/stage_outputs/01_project_skeleton_result.md

## Checks

Before committing, verify:

- Swift files exist.
- SmoruApp exists.
- AppRouter exists.
- Placeholder SwiftUI views exist.
- SwiftData container setup exists.
- The stage output file exists.
- The project can be opened in Xcode, or the limitation is written in the stage output.

## Stop conditions

Stop and report failure if:

- No SwiftUI app structure exists.
- Only a static mockup was created.
- No stage output was created.
