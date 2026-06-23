import SwiftUI
import AuthenticationServices

struct EntryView: View {
    @EnvironmentObject private var appRouter: AppRouter
    @EnvironmentObject private var appState: AppState
    @Environment(\.appDependencies) private var dependencies

    @State private var statusMessage: String = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                PlaceholderScreen(
                    title: "SMORU Entry",
                    subtitle: "Continue with Apple, Continue with Google, or Try without login."
                )

                SignInWithAppleButton(.continue) { request in
                    request.requestedScopes = [.fullName, .email]
                } onCompletion: { result in
                    Task {
                        await handleAppleSignIn(result)
                    }
                }
                .signInWithAppleButtonStyle(.black)
                .frame(height: 50)
                .padding(.horizontal, 24)

                PrimaryButton(title: "Continue with Google") {
                    Task {
                        await handleGoogleSignIn()
                    }
                }
                .padding(.horizontal, 24)

                Button("Try without login") {
                    dependencies.authManager.continueAsTrial()
                    appState.isTrialModeEnabled = true
                    statusMessage = "Trial mode enabled"
                    appRouter.route(to: .trialHome)
                }
                .buttonStyle(.bordered)

                if !statusMessage.isEmpty {
                    Text(statusMessage)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 16) {
                    Link("Terms", destination: URL(string: "https://example.com/terms")!)
                    Link("Privacy", destination: URL(string: "https://example.com/privacy")!)
                }
                .font(.footnote)
            }
            .padding(.vertical, 12)
        }
    }

    private func handleAppleSignIn(_ result: Result<ASAuthorization, Error>) async {
        switch result {
        case .success(let authorization):
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                statusMessage = "Apple sign-in structure is ready."
                return
            }

            let tokenData = credential.identityToken
            let identityToken = tokenData.flatMap { String(data: $0, encoding: .utf8) }
            let success = await dependencies.authManager.signInWithApple(
                userIdentifier: credential.user,
                identityToken: identityToken
            )

            if success {
                appState.isTrialModeEnabled = false
                statusMessage = "Signed in with Apple"
                appRouter.route(to: .healthKitIntro)
            }

        case .failure:
            statusMessage = "Apple sign-in canceled or failed"
        }
    }

    private func handleGoogleSignIn() async {
        let success = await dependencies.authManager.signInWithGoogle()
        if success {
            appState.isTrialModeEnabled = false
            statusMessage = "Signed in with Google (placeholder flow)"
            appRouter.route(to: .healthKitIntro)
        } else {
            statusMessage = "Google sign-in failed"
        }
    }
}
