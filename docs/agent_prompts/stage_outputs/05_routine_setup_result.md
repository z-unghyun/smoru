# Stage 05 Routine Setup Result

## Scope
- Implemented template selection, routine setup, and task editor screens.
- Added mode-behavior editing (expanded/basic/reduced) and end-time schedule preview.

## Implemented
- `RoutineTemplateSelectionView`
  - Seeds sample templates when empty.
  - Selects one routine template and routes to setup.
- `RoutineSetupView`
  - Edits routine end time.
  - Shows schedule preview by selected mode using `RoutineScheduleEngine`.
  - Displays current tasks and routes to task editor.
- `TaskEditorView`
  - Creates/edits tasks with task types:
    - basic
    - alarm-like
    - multi-timer
    - app-open
    - link-open
  - Edits per-mode behavior:
    - keep / replace / skip
  - Stores replacement duration for replace action.
- `DomainSampleData`
  - Added sample routine templates with per-mode variant behavior.
  - Reduced mode in samples shortens the schedule versus basic.

## Rule Compliance
- One routine template contains all three mode variants.
- End-time based schedule preview computes start time backwards.
- Reduced mode behavior uses skip/replace to shorten duration.

## Stage 05 Checks
- Template selection exists -> PASS
- Setup screen can edit end time -> PASS
- Task editor can create basic/link/app-open task data -> PASS
- Each task has expanded/basic/reduced behavior -> PASS
- Schedule preview changes by mode -> PASS
- Reduced preview shorter than basic in sample data -> PASS
- Stage output exists -> PASS

## Limits
- UI polish and validation messages are intentionally minimal in this stage.

## Stage 05 Status
- PASS
- Ready to proceed to Stage 06.
