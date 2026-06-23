# Stage 06 — Routine Focus Mode and Notifications

## Goal

Build the timed routine focus screen and local notification flow.

## Prompt for coding agent

Read the Agent Implementation Spec and native addenda first.

Build:

- RoutineFocusView
- RoutineSessionEngine connection
- local routine start notification
- notification route into RoutineFocusView
- timed task progress
- automatic transition to next task
- pause and resume from the large center button
- top-left small exit action
- next task preview on the left side
- optional voice guide at task start

Focus screen layout:

- immersive background
- current task very large in the center
- remaining time near the current task
- large center pause/resume button
- small top-left exit button
- next task preview on the left side

Behavior:

- The large center button pauses or resumes.
- Leaving the full routine is the top-left exit action.
- When the task duration ends, move to the next task automatically.
- Auto transition keeps the planned end time aligned.
- Use local notification to bring the user back, then route to the focus screen.

Create this stage output:

- docs/agent_prompts/stage_outputs/06_focus_notifications_result.md

## Checks

Verify:

- RoutineFocusView exists
- current task is visually dominant
- large center button pauses and resumes
- top-left button exits the routine
- task time ending advances automatically
- next task preview is visible
- local notification can be scheduled
- notification payload routes to focus view
- stage output exists

## Stop conditions

Stop if:

- execution is only a checklist screen
- task transition requires manual completion only
- center button exits the whole routine
- notification routing is missing
- no stage output is created
