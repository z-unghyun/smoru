import Foundation
import Combine

enum AuthProvider: String {
    case apple
    case google
    case trial
}

struct AuthSession {
    let userID: String
    let provider: AuthProvider
    let isTrial: Bool
}

@MainActor
final class AuthManager: ObservableObject {
    @Published private(set) var currentSession: AuthSession?

    private let keychain: KeychainStore
    private let firebaseClient: FirebaseClient

    init(keychain: KeychainStore = KeychainStore(), firebaseClient: FirebaseClient = FirebaseClient()) {
        self.keychain = keychain
        self.firebaseClient = firebaseClient
    }

    func signInWithApple(userIdentifier: String, identityToken: String?) async -> Bool {
        let token = identityToken ?? "apple-placeholder-token"
        _ = keychain.save(token, for: "smoru.auth.apple.token")

        let session = AuthSession(userID: userIdentifier, provider: .apple, isTrial: false)
        currentSession = session
        _ = await firebaseClient.syncUserProfile(userID: userIdentifier, provider: AuthProvider.apple.rawValue, isTrial: false)
        await firebaseClient.trackEvent(label: "auth_apple_signin")
        return true
    }

    func signInWithGoogle() async -> Bool {
        let generatedID = "google-user-\(UUID().uuidString)"
        _ = keychain.save("google-placeholder-token", for: "smoru.auth.google.token")

        let session = AuthSession(userID: generatedID, provider: .google, isTrial: false)
        currentSession = session
        _ = await firebaseClient.syncUserProfile(userID: generatedID, provider: AuthProvider.google.rawValue, isTrial: false)
        await firebaseClient.trackEvent(label: "auth_google_signin")
        return true
    }

    func continueAsTrial() {
        currentSession = AuthSession(userID: "trial-\(UUID().uuidString)", provider: .trial, isTrial: true)
    }

    func signOut() {
        _ = keychain.delete(for: "smoru.auth.apple.token")
        _ = keychain.delete(for: "smoru.auth.google.token")
        currentSession = nil
    }
}
