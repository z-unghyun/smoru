# Stage 07 — Auth, Firebase, and Privacy

## Goal

Add login structure, backend placeholders, and privacy screens.

## Prompt for coding agent

Read the Agent Implementation Spec and native addenda first.

Build:

- Sign in with Apple structure
- Google Sign-In structure
- trial mode path
- AuthManager
- Keychain wrapper
- FirebaseClient placeholder
- repository interfaces
- example config files
- privacy and data screen
- error report screen
- feature request screen

Backend V1 remote scope:

- user profile
- routine settings backup
- settings backup
- error reports
- feature requests
- minimal event labels

Local only in V1:

- health source data
- routine execution records
- task execution records

Rules:

- Do not commit real keys.
- Do not commit real backend config.
- Include example config only.
- Trial mode must work without login.
- Email and password login is not V1.

Create this stage output:

- docs/agent_prompts/stage_outputs/07_auth_firebase_result.md

## Checks

Verify:

- Apple login structure exists
- Google login structure exists
- trial mode still works
- Keychain wrapper exists
- backend placeholder config exists
- real config is absent
- privacy screen explains local and remote data
- error report and feature request flows exist
- stage output exists

## Stop conditions

Stop if:

- real keys are added
- trial mode is removed
- email/password flow becomes required V1 work
- health source data is prepared for remote storage
- no stage output is created
