# Stage 08 Acceptance Checks Result

## Pass Or Fail
- PASS (with non-macOS build-tool limitation noted)

## Implemented Items
- iOS project exists (`Smoru.xcodeproj`)
- SwiftUI-based UI and app entry
- HealthKit explanation -> permission -> fetch structure
- Manual fallback path and local manual summary creation
- SwiftData local model set (required V1 model family)
- Home integrated daily visual (Sleep Fragment)
- History monthly fragment collection + date detail route
- Routine template selection, setup, task editor, mode behavior editing
- Three routine modes (`expanded`, `basic`, `reduced`) under one routine model
- Routine focus mode full-screen view with dominant current task
- Timed task auto-advance and pause/resume center button
- Top-left exit action for full routine exit
- Local routine start notification scheduling
- Notification payload route to focus view
- Trial mode path without login
- Apple login and Google login structures
- Firebase placeholder structures and repository interfaces
- Example-only backend config files (no real keys committed)
- Privacy/data screen and feedback flows (error report, feature request)

## Missing Items
- No runtime-verified Apple/Google/Firebase production integration (placeholder-only by design)
- No macOS/Xcode runtime validation in this environment

## Build Steps
1. Open `Smoru.xcodeproj` in Xcode on macOS.
2. Configure signing/team and iOS target.
3. Add `HealthKit` capability and usage description.
4. Copy `GoogleService-Info.plist.example` -> `GoogleService-Info.plist` and fill local values.
5. Copy `Smoru/Core/Firebase/FirebaseConfig.example.swift` -> `Smoru/Core/Firebase/FirebaseConfig.swift` and fill local values.
6. Build and run on iOS 17+ simulator/device.

## Test Steps
1. Entry: Apple / Google / Trial buttons and links.
2. Trial path: open trial home and sample fragment rendering.
3. HealthKit intro + permission flow.
4. Deny or simulate no-data -> confirm manual input route.
5. Submit manual input -> confirm local summary appears on home.
6. Open routine templates -> select template -> edit end time.
7. Add/edit task with mode behavior (`keep/replace/skip`) and check preview changes.
8. Confirm reduced preview is shorter than basic in sample template.
9. Start routine focus -> verify pause/resume center button and top-left exit.
10. Let task timer reach zero -> verify auto transition to next task.
11. Schedule routine notification -> tap notification -> verify focus route.
12. Open privacy, error report, and feature request screens.

## Known Limitations
- `xcodebuild` is unavailable in this environment (non-macOS), so compile/run checks are documented but not executed here.
- Google sign-in and Firebase APIs are placeholder structures awaiting owner configuration.

## Owner Setup Needed
- Apple Developer Team/signing configuration
- HealthKit capability enablement in Xcode
- Real Google OAuth and URL scheme setup
- Real Firebase project settings and local config files
- Optional tuning of Sleep Fragment visual constants and voice behavior
