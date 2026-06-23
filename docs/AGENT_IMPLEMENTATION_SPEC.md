# SMORU Agent Implementation Spec

This file is the highest-priority implementation contract for coding agents. If it conflicts with older PRD, SRD, BRD, or design drafts, follow this file first.

## 1. Required deliverable

Build a native iOS app.

Allowed stack:
- Swift
- SwiftUI
- HealthKit
- SwiftData
- UserNotifications
- AuthenticationServices
- GoogleSignIn integration structure
- Firebase integration structure

Not allowed:
- Single HTML prototype as final output
- React, Vite, or Next.js app as final output
- Static mockup only

HTML may exist only under `prototype/` as reference material.

## 2. V1 product decisions

- Platform: iOS only
- Minimum iOS version: iOS 17+
- UI framework: SwiftUI
- Local persistence: SwiftData
- Health data: HealthKit read-only access
- Notification: local notifications
- Authentication: Apple + Google
- Backend: Firebase, free-tier friendly usage
- Trial mode: enabled
- Apple Watch missing case: app remains usable with manual condition input
- Routine modes: 확장 / 기본 / 축소
- First routine creation: select template, then edit
- Routine execution: full-screen focus mode, not checklist-first UI
- Sleep visualization: one integrated Sleep Fragment object

## 3. Firebase usage

Use Firebase as the V1 backend. Provide only placeholder configuration files in the repository.

Firebase V1 scope:
- Authentication provider structure for Apple and Google
- Firestore collections for profile, routine setting backup, error reports, feature requests
- Crashlytics integration placeholder
- Analytics integration placeholder with minimal events

Do not require Cloud Functions in V1.

HealthKit source data is processed locally. V1 server backup stores profile and routine settings only, not execution records.

## 4. HealthKit requirements

Request HealthKit permission only after a clear explanation screen.

V1 read types:
- sleepAnalysis
- heartRate
- heartRateVariabilitySDNN
- respiratoryRate
- stepCount or activeEnergyBurned

Optional V2 types:
- oxygenSaturation
- wrist temperature if available
- workout

If HealthKit authorization is denied or data is missing, show manual condition input and keep the app usable.

## 5. Sleep Fragment

SMORU must show one integrated Sleep Fragment, not multiple separate score cards.

The Sleep Fragment is a single organic blob-like object generated from sleep metrics.

Metric to visual property mapping:
- Total sleep duration: overall size
- Sleep quality and interruptions: edge roughness / bumpiness
- Total score: continuous color gradient
- Sleep stability: left-right balance and symmetry
- HRV recovery score: inner glow strength
- Sleep heart rate stability: subtle surface vibration
- Respiratory stability: roundness / softness
- Data quality: opacity and sharpness

V1 implementation:
- Use SwiftUI Shape, Canvas, Path, gradient, blur, shadow, and TimelineView.
- Do not use a 3D engine.
- Support Reduce Motion.
- Home shows today's Sleep Fragment.
- History shows a monthly collection of date-based Sleep Fragments.

## 6. Routine model

SMORU has one routine with three modes, not three unrelated routines.

Modes:
- 확장: longer or stronger version
- 기본: normal version
- 축소: shorter and easier version

Reduced routine rule:
- Keep only essential tasks.
- Shorten duration where appropriate.
- A task may be kept, replaced, or skipped per mode.

Routine scheduling:
- User sets routine end time.
- Each mode has the same end time.
- Start time is calculated backwards from total duration.

Example:
- End time 08:30
- 확장 60 min -> start 07:30
- 기본 35 min -> start 07:55
- 축소 15 min -> start 08:15

## 7. Routine Focus Mode

Routine execution must use a full-screen focus view similar in intention to Yeolpumta-style focus screens.

Required layout:
- Immersive background based on Sleep Fragment or routine mode
- Current task name displayed very large in the center
- Current task time/progress near the center
- Large center control button used as pause/resume
- Small exit button at the top-left
- Next task preview displayed on the left side
- Optional timeline/progress indicator

Behavior:
- At the scheduled routine time, send a local notification.
- When user taps notification or starts routine from Home, open RoutineFocusView.
- When the current task time ends, automatically move to the next task.
- At each task transition, read the task name if voice guide is enabled.
- The large center button is pause/resume, not final exit.
- Complete routine termination is handled by the small top-left exit button.
- Exit must always be available.

Important iOS limitation:
- The app cannot force-open a full-screen view while terminated.
- Use local notification to bring the user back, then route to RoutineFocusView.

## 8. Task types

V1 task types:
- Basic task
- Alarm-like task
- Multi-timer task
- App open task
- Link open task

App open task:
- User taps a button.
- App attempts to open a registered URL scheme or universal link.
- If iOS shows an app-opening confirmation, that is acceptable.
- If opening fails, show fallback guidance.
- Do not attempt automatic background app launching.

## 9. Required screens

Minimum screens:
- Entry screen with Apple login, Google login, and trial mode
- Trial mode sample home
- HealthKit explanation screen
- HealthKit permission state screen
- Manual condition input screen
- Home screen with integrated Sleep Fragment and today's routine
- Sleep report screen
- Routine setup screen
- Routine template selection screen
- Task add/edit overlay
- Routine Focus Mode screen
- History monthly Sleep Fragment collection
- Date detail screen
- Settings screen
- Privacy/data management screen
- Error report screen
- Feature request screen

## 10. Acceptance checklist

The implementation is accepted only if:

- The project opens as an iOS app project in Xcode.
- The main UI is written in SwiftUI.
- HealthKit capability and authorization flow are present.
- SwiftData models are present.
- Local notification scheduling is present.
- RoutineFocusView exists and follows the focus-mode layout.
- SleepFragmentView exists and maps metrics to shape parameters.
- Apple login structure exists.
- Google login structure exists with placeholder configuration.
- Firebase structure exists with placeholder configuration.
- Trial mode works without login.
- Manual condition input works without HealthKit.
- Root-level single HTML is not the final app.
