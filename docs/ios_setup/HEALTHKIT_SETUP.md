# HealthKit Setup (Owner Action)

To run HealthKit flow on a real iOS build, configure this in Xcode:

1. Open `Smoru.xcodeproj`.
2. Select target `Smoru` -> `Signing & Capabilities`.
3. Add capability: `HealthKit`.
4. Ensure app signing/team is configured for your Apple Developer account.
5. Add or verify `NSHealthShareUsageDescription` in app Info settings.
6. Build and run on an iOS device with Apple Health data.

Notes:
- SMORU only reads health data for local routine adaptation.
- If permission is denied/unavailable/no-data, the app falls back to manual input.
- Do not upload raw HealthKit samples to backend services in V1.
