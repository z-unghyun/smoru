# Stage 00 Repo Audit Result

## Scope
- Stage goal: repository audit and execution plan only.
- No app implementation started in this stage.

## Current Repository State
- Remote: `https://github.com/z-unghyun/smoru.git` on `main`.
- Root-level `index.html`: not present.
- Prototype HTML: `prototype/index.html` exists and is treated as reference-only.
- Native iOS project: not present yet (`.xcodeproj`, `.swift`, `.xcworkspace` missing).
- Required spec documents found:
  - `docs/AGENT_IMPLEMENTATION_SPEC.md`
  - `docs/smoru_prd_v1_native_addendum.md`
  - `docs/smoru_srd_v1_native_addendum.md`
  - `docs/agent_prompts/STAGED_ORDER_V2.md`
  - `docs/agent_prompts/README.md`

## Priority Rule Applied
- 1st: `docs/AGENT_IMPLEMENTATION_SPEC.md`
- 2nd: `docs/smoru_prd_v1_native_addendum.md`
- 3rd: `docs/smoru_srd_v1_native_addendum.md`
- 4th: older BRD/PRD/SRD/design docs if needed

## Required Native Target (Confirmed)
- Swift + SwiftUI iOS app (iOS 17+)
- HealthKit read flow with explanation and fallback
- SwiftData local models
- UserNotifications local notifications
- Apple + Google auth structure
- Firebase placeholder structure with no secrets
- Integrated Sleep Fragment (home + monthly history)
- Routine setup and focus mode with timed auto-advance

## Stage-by-Stage Execution Plan
1. Stage 01: Create Xcode-ready iOS project skeleton and baseline app modules.
2. Stage 02: Add SwiftData models and core domain engines.
3. Stage 03: Implement HealthKit manager, onboarding explanation, manual fallback path.
4. Stage 04: Implement SleepFragment view and Home/History visuals.
5. Stage 05: Implement routine template selection, setup, and task editor.
6. Stage 06: Implement RoutineFocusView, timer auto-advance, local notification routing.
7. Stage 07: Add auth/Firebase placeholder integrations and privacy/data management screens.
8. Stage 08: Run acceptance checks, produce final acceptance artifact, finalize fixes.

## Risks and Constraints
- This environment cannot run Xcode directly (non-macOS), so buildability must be validated via project structure and static checks in this stage execution.
- HealthKit behavior cannot be fully runtime-verified here; fallback paths and API structure will be verified by code and stage checks.
- Sign in with Apple / Google / Firebase runtime setup requires owner-side Apple/Firebase project configuration.

## Open Decisions / Owner Inputs
- Final bundle identifier and Apple Developer Team ID.
- Firebase project IDs and runtime plist provisioning.
- Google OAuth client details and URL scheme values.
- Exact visual tuning constants for Sleep Fragment motion and colors.

## Stage 00 Check Result
- Check: root-level `index.html` absent -> PASS
- Check: required docs exist -> PASS
- Check: stage output file exists -> PASS

## Stage 00 Status
- PASS
- Ready to proceed to Stage 01.
