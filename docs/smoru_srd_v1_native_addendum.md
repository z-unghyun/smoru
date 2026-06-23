# SMORU SRD V1 Native Addendum

This addendum supplements and overrides ambiguous parts of the earlier SRD.

## 1. Final technical stack

V1 stack:
- Swift
- SwiftUI
- iOS 17+
- HealthKit
- SwiftData
- Swift Charts where needed
- UserNotifications
- AuthenticationServices for Apple login
- GoogleSignIn SDK integration structure
- Firebase Auth / Firestore / Crashlytics / Analytics integration structure

Do not implement the product as a web app.

## 2. Required modules

```text
Smoru/
├─ App/
│  ├─ SmoruApp.swift
│  ├─ AppState.swift
│  ├─ AppRouter.swift
│  └─ AppDependencyContainer.swift
├─ Core/
│  ├─ HealthKit/HealthKitManager.swift
│  ├─ Notifications/NotificationManager.swift
│  ├─ Auth/AuthManager.swift
│  ├─ Firebase/FirebaseClient.swift
│  ├─ Security/KeychainStore.swift
│  └─ Logging/AppLogger.swift
├─ Domain/
│  ├─ Sleep/SleepConditionScoreEngine.swift
│  ├─ Sleep/SleepFragmentParameterEngine.swift
│  ├─ Routine/RoutineModeEngine.swift
│  ├─ Routine/RoutineScheduleEngine.swift
│  └─ Routine/RoutineSessionEngine.swift
├─ Data/
│  ├─ Models/
│  └─ Repositories/
├─ Features/
│  ├─ Entry/
│  ├─ Onboarding/
│  ├─ Home/
│  ├─ SleepReport/
│  ├─ RoutineSetup/
│  ├─ RoutineFocus/
│  ├─ History/
│  └─ Settings/
└─ DesignSystem/
   ├─ Colors.swift
   ├─ Typography.swift
   ├─ Components/
   └─ SleepFragmentView.swift
```

## 3. App state routing

Required app routes:
- entry
- trialHome
- healthKitIntro
- healthKitPermissionState
- manualConditionInput
- home
- sleepReport
- routineTemplateSelection
- routineSetup
- taskEditor
- routineFocus
- history
- dateDetail
- settings
- privacyData
- errorReport
- featureRequest

Startup routing:

```text
Launch
→ check trial/auth state
→ if first run: entry
→ if HealthKit missing: manual input or HealthKit intro
→ if routine missing: template selection
→ else: home
```

Notification routing:

```text
Local notification tapped
→ app opens
→ AppRouter receives notification payload
→ if payload.type == routineStart: route to RoutineFocusView
→ if payload.type == nightChecklist: route to night checklist
```

## 4. HealthKitManager

Responsibilities:
- Check HealthKit availability
- Request read authorization
- Fetch sleep samples for recent days
- Fetch heart rate during sleep session
- Fetch HRV SDNN during sleep session
- Fetch respiratory rate during sleep session
- Fetch step count or active energy for context
- Build DailySleepSummary
- Return missing-data state without crash

Required read types:
- HKCategoryTypeIdentifier.sleepAnalysis
- HKQuantityTypeIdentifier.heartRate
- HKQuantityTypeIdentifier.heartRateVariabilitySDNN
- HKQuantityTypeIdentifier.respiratoryRate
- HKQuantityTypeIdentifier.stepCount or HKQuantityTypeIdentifier.activeEnergyBurned

Session rule:
- Today sleep is the longest sleep session completed before today's morning boundary.
- Do not split sleep only by calendar day 00:00 to 23:59.
- Naps are excluded from V1 mode decision or displayed only as supporting information.

## 5. SwiftData models

Required local models:

```swift
@Model final class UserSettingsModel
@Model final class DailySleepSummaryModel
@Model final class SleepConditionScoreModel
@Model final class SleepFragmentParametersModel
@Model final class RoutineTemplateModel
@Model final class RoutineTaskModel
@Model final class RoutineModeVariantModel
@Model final class RoutineSessionModel
@Model final class RoutineTaskRecordModel
@Model final class NightChecklistItemModel
@Model final class NightChecklistRecordModel
@Model final class ManualConditionInputModel
```

Required enums:

```swift
enum RoutineMode: String, Codable { case expanded, basic, reduced }
enum RoutineTaskType: String, Codable { case basic, alarmLike, multiTimer, appOpen, linkOpen }
enum RoutineTaskModeAction: String, Codable { case keep, replace, skip }
enum SleepDataSource: String, Codable { case healthKit, manual, sample }
enum RoutineSessionState: String, Codable { case scheduled, running, paused, completed, exited }
```

## 6. Sleep scoring

Input:
- DailySleepSummary
- User baseline
- Night checklist record if available
- Manual condition input if HealthKit is unavailable

Score components:
- durationScore
- stabilityScore
- recoveryScore
- stageBalanceScore
- respiratoryStabilityScore
- dataQualityScore

Readiness:

```text
sleepConditionScore = weighted sleep score
morningPreparationScore = night checklist score
readinessScore = sleepConditionScore * 0.8 + morningPreparationScore * 0.2

if readinessScore >= 80: mode = expanded
else if readinessScore >= 55: mode = basic
else: mode = reduced
```

Use wellness wording. Do not diagnose disease or sleep disorder.

## 7. Sleep Fragment parameters

Required struct:

```swift
struct SleepFragmentParameters: Codable, Equatable {
    var date: Date
    var totalScore: Double
    var durationRatio: Double
    var edgeRoughness: Double
    var colorProgress: Double
    var symmetry: Double
    var innerGlow: Double
    var surfaceVibration: Double
    var roundness: Double
    var opacity: Double
    var sharpness: Double
    var seed: Int
}
```

Mapping:

```text
durationRatio = clamp(totalSleepMinutes / targetSleepMinutes, 0.70, 1.20)
edgeRoughness = normalize(awakeMinutes + wakeCountPenalty + lowEfficiencyPenalty)
colorProgress = clamp(totalScore / 100, 0, 1)
symmetry = normalize(stabilityScore)
innerGlow = normalize(recoveryScore)
surfaceVibration = inverseNormalize(heartRateStability)
roundness = normalize(respiratoryStabilityScore)
opacity = mapDataQuality(dataQualityScore)
sharpness = mapDataQuality(dataQualityScore)
seed = deterministic value from date
```

SleepFragmentView implementation:
- SwiftUI Shape or Canvas
- gradient fill
- highlight overlay
- inner glow
- subtle float animation
- Reduce Motion fallback
- deterministic shape for same date

## 8. Routine schedule engine

Input:
- RoutineTemplate
- RoutineMode
- routineEndTime

Output:
- TodayRoutinePlan
- ordered tasks
- start time
- end time
- task time ranges

Rules:
- Each mode shares the same end time.
- Start time is calculated from total active duration.
- Skipped tasks are not included in duration.
- Replaced tasks use replacement duration.
- Reduced mode should generally be shorter than basic.

## 9. RoutineFocusView technical requirements

Required state:

```swift
struct RoutineFocusState {
    var sessionId: UUID
    var mode: RoutineMode
    var tasks: [ScheduledRoutineTask]
    var currentIndex: Int
    var sessionState: RoutineSessionState
    var currentTaskStartedAt: Date?
    var currentTaskEndsAt: Date?
    var remainingSeconds: Int
    var elapsedSeconds: Int
    var isVoiceGuideEnabled: Bool
}
```

Required actions:

```swift
startSession()
pauseSession()
resumeSession()
exitSession()
advanceToNextTaskAutomatically()
handleTaskTimeEnded()
readCurrentTaskNameIfNeeded()
```

Behavior:
- Start from local notification tap or Home start button.
- Show current task full-screen.
- Read task name at task start if enabled.
- Auto-advance when current task duration ends.
- Center button toggles pause/resume.
- Top-left small exit button exits the full routine.
- Exiting stores local RoutineSessionState.exited.
- Completion stores local RoutineSessionState.completed.

No checklist-first execution UI.

## 10. App open and link tasks

Use SwiftUI `openURL` or UIKit URL opening depending on architecture.

Behavior:
- User taps the app/link task action.
- App attempts to open URL scheme or universal link.
- iOS may show a confirmation prompt for opening another app.
- If open fails, show a fallback message.
- Do not attempt background auto-launch.

Required fields:

```swift
var launchURLString: String?
var fallbackURLString: String?
var appDisplayName: String?
```

## 11. NotificationManager

Required notifications:
- routineStart
- wakeOrMorningStart
- incompleteRoutineReminder
- nightChecklistReminder

Notification payload must include route information.

Example payload fields:

```text
type = routineStart
routineDate = yyyy-mm-dd
mode = expanded/basic/reduced
```

V1 uses local notifications only.

## 12. Firebase data model

Use Firebase with placeholder setup.

Suggested collections:

```text
users/{userId}
users/{userId}/routineBackups/{routineId}
users/{userId}/settings/current
errorReports/{reportId}
featureRequests/{requestId}
analyticsEvents/{eventId}
```

Do not store:
- Raw HealthKit samples
- Full sleep stage timeline
- Routine execution records in V1
- Task execution records in V1

Firestore rules should be user-scoped for user documents.

## 13. Authentication

V1 providers:
- Sign in with Apple
- Google Sign-In
- Trial mode without account

Email/password auth is V2, not V1.

Auth tokens are stored using Keychain.

## 14. Configuration files

Repository should include example config only:
- `GoogleService-Info.plist.example`
- `FirebaseConfig.example.swift` if needed
- `.gitignore` excluding actual local config files

The app must compile after a developer adds their own local config file.

## 15. Testing requirements

Minimum tests:
- RoutineScheduleEngine calculates start/end times correctly.
- Reduced routine shortens task list and duration.
- SleepFragmentParameterEngine returns deterministic seed for a date.
- Missing HealthKit data returns manual input path.
- RoutineFocusEngine auto-advances task by duration.
- Pause/resume changes session state correctly.
- Exit records exited state locally.
- App open task handles invalid URL gracefully.

## 16. Done definition

V1 technical work is done when:
- The app builds in Xcode.
- Main screens are SwiftUI.
- HealthKit authorization flow exists.
- Manual condition fallback exists.
- SleepFragmentView is implemented.
- Routine template selection exists.
- Routine setup and task editor exist.
- RoutineFocusView uses timed auto-advance.
- Local notifications route to RoutineFocusView.
- SwiftData local models exist.
- Firebase structure is placeholder-only.
- Root HTML is not treated as final product.
