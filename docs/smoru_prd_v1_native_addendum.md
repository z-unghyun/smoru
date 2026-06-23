# SMORU PRD V1 Native Addendum

This addendum supplements and overrides ambiguous parts of the earlier PRD.

## 1. V1 product definition

SMORU V1 is a native iOS wellness routine app. It reads permitted Apple Health sleep-related data, creates one integrated Sleep Fragment, and adapts the user's morning routine into 확장, 기본, or 축소 mode.

V1 must not be delivered as a web-only prototype.

## 2. Entry and onboarding

V1 entry screen contains:
- Continue with Apple
- Continue with Google
- Try without login
- Terms and privacy links

Email/password sign-up, ID lookup, and password reset are not V1 requirements. They can remain as V2 candidates.

First-time flow:

```text
App launch
→ Entry screen
→ Apple / Google login or trial mode
→ HealthKit explanation screen
→ HealthKit permission request
→ if permission granted: fetch recent sleep data
→ if permission denied or unavailable: manual condition input
→ routine template selection
→ routine edit
→ Home
```

Trial mode:
- Shows sample Sleep Fragment.
- Shows sample routine.
- Does not require login.
- Can later connect HealthKit and sign in.

## 3. HealthKit user experience

Before showing the system permission sheet, SMORU explains what it reads and why.

Required explanation points:
- SMORU reads sleep-related records from Apple Health.
- The purpose is to create today's Sleep Fragment and recommend routine mode.
- The app remains usable even without Apple Watch or HealthKit data.
- User can use manual condition input.

V1 HealthKit read scope:
- Sleep analysis
- Heart rate
- HRV SDNN
- Respiratory rate
- Step count or active energy

## 4. Manual condition input

Manual input appears when:
- HealthKit is unavailable
- HealthKit permission is denied
- Sleep data for today is missing
- User is in trial mode and wants a simulated routine

Manual fields:
- How long did you sleep?
- How rested do you feel?
- Did you wake up often?
- Do you want 확장, 기본, or 축소 today?

Manual input creates a local DailySleepSummary with source = manual.

## 5. Integrated Sleep Fragment

SMORU has one main Sleep Fragment per day.

It is not a collection of separate charts. It is one visual object whose shape expresses multiple sleep-related scores.

Mapping:

| Metric | Visual property |
|---|---|
| Total sleep duration | Size |
| Sleep quality / interruptions | Edge bumpiness |
| Total condition score | Continuous color gradient |
| Sleep stability | Symmetry and balance |
| HRV recovery | Inner glow |
| Heart rate stability | Surface vibration |
| Respiratory stability | Roundness |
| Data quality | Opacity and sharpness |

Color mapping:
- Use continuous gradient for total score.
- Internally store a 5-level label if helpful.
- Avoid harsh red warning colors.

History:
- Home shows today's Sleep Fragment.
- History shows monthly Sleep Fragment collection.
- Date detail opens past fragment, sleep report, and routine result.

## 6. Routine modes

V1 user-facing mode names:
- 확장
- 기본
- 축소

Definitions:
- 확장: sleep condition is strong enough to run a longer or richer version.
- 기본: normal planned version.
- 축소: low-condition version that keeps only essentials and shortens duration.

Reduced mode is not a vague recovery concept. It is a concrete shorter routine.

Reduced routine rule:
- Essential tasks remain.
- Nonessential tasks may be skipped.
- Time-consuming tasks may be replaced with shorter versions.
- Reduced mode generally reduces both task count and total duration.

## 7. Routine creation

First routine creation uses template selection, then edit.

Suggested templates:
- 가벼운 아침형
- 운동형
- 공부형
- 출근/등교형

After template selection, user edits:
- Routine end time
- Task list
- Mode behavior per task
- Voice guide setting
- Notification setting

## 8. Routine scheduling

SMORU uses end-time based scheduling.

The user decides when the morning routine should finish. Each mode calculates start time backwards from total duration.

Example:

```text
End time: 08:30
확장: 60 min -> 07:30 start
기본: 35 min -> 07:55 start
축소: 15 min -> 08:15 start
```

The app decides which mode to notify based on today's readiness.

## 9. Routine Focus Mode

Routine execution screen is a full-screen focus mode, not a checklist-first screen.

Required layout:
- Background opens into a focus screen at routine start.
- Current task appears very large at the center.
- Remaining time or progress is visible.
- Large center button pauses/resumes the current routine.
- Top-left small exit button ends the routine.
- Next task preview appears on the left side.
- Visual priority is current task first, pause button second, exit button low priority.

Behavior:
- When a task time ends, the app automatically advances to the next task.
- The app reads the task name at task start if voice guide is on.
- Auto-advance is preferred because it keeps the routine timeline aligned with the planned end time.
- The large center button is pause/resume, not full termination.
- Full termination is the top-left exit action.

## 10. Task types

V1 task types:

| Type | Product behavior |
|---|---|
| Basic | Timed task with name and optional voice guide |
| Alarm-like | Local notification plus focus view; not unlimited background alarm |
| Multi-timer | One task with repeated sub-steps |
| App open | User taps to open another app through URL scheme or universal link |
| Link open | Opens web/universal link |

App open task means exactly this level of support:
- User taps app/link task.
- iOS may show a confirmation such as opening another app.
- If allowed, target app opens.
- If not possible, SMORU shows a fallback message.

## 11. Notifications

V1 notification types:
- Wake/routine start notification
- Routine start notification
- Incomplete routine reminder
- Night checklist reminder

All are local notifications.

## 12. Firebase and server scope

Firebase is used for small-scale V1 backend needs.

V1 stores remotely:
- User profile
- Routine settings backup
- Error reports
- Feature requests
- Optional minimal event labels

V1 does not store remotely:
- Raw HealthKit data
- Routine execution records
- Task execution records
- Detailed sleep sample timeline

## 13. V1 success criteria

The PRD is satisfied when the native app supports:
- Apple and Google entry path
- Trial mode
- HealthKit explanation and permission request
- Manual condition input fallback
- Integrated Sleep Fragment
- Template-based routine creation
- 확장/기본/축소 routine variants
- End-time based schedule
- Routine Focus Mode with auto task transition
- Local notifications
- Monthly Sleep Fragment history
- Settings, error report, feature request
