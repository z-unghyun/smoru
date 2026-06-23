# Stage 07 Auth and Firebase Result

## Scope
- Added auth/provider structure, backend placeholder interfaces, and privacy/feedback screens.
- Kept trial-mode path active and credential-free.

## Implemented
- Apple login structure:
  - `SignInWithAppleButton` flow in `EntryView`
  - `AuthManager.signInWithApple(...)` placeholder session handling
- Google login structure:
  - Google sign-in placeholder action in `EntryView`
  - `AuthManager.signInWithGoogle()` placeholder session handling
- Trial mode:
  - `Try without login` remains active and routes to trial flow
- Security and auth foundation:
  - `KeychainStore` now wraps save/read/delete
  - `AuthManager` tracks session and sign-out
- Firebase placeholders:
  - `FirebaseClient` methods for user profile/settings backups, error/feature submissions, minimal events
  - no raw HealthKit upload methods added
- Repository interfaces:
  - `UserProfileRepository`
  - `RoutineSettingsRepository`
  - `FeedbackRepository`
  - placeholder repository implementations provided
- Example config files:
  - `GoogleService-Info.plist.example`
  - `Smoru/Core/Firebase/FirebaseConfig.example.swift`
  - `.gitignore` blocks real `GoogleService-Info.plist` and `FirebaseConfig.swift`
- Privacy / data screen:
  - clearly describes local-only vs remote placeholder scope
- Error report / feature request:
  - form flows implemented and connected to placeholder Firebase client

## Stage 07 Checks
- Apple login structure exists -> PASS
- Google login structure exists -> PASS
- Trial mode still works -> PASS
- Keychain wrapper exists -> PASS
- Backend placeholder config exists -> PASS
- Real config is absent -> PASS
- Privacy screen explains local and remote data -> PASS
- Error report and feature request flows exist -> PASS
- Stage output exists -> PASS

## Limits
- Apple/Google/Firebase runtime credentials are intentionally not included.
- Google sign-in and Firebase calls are placeholder-only in this stage.

## Stage 07 Status
- PASS
- Ready to proceed to Stage 08 final acceptance.
