// AuthenticationViewModel.swift
// Manages authentication flows

import Foundation
import Combine

final class AuthenticationViewModel: ObservableObject {
    @Published var state = AuthenticationState()
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    private var cancellables = Set<AnyCancellable>()

    func sendOTP() {
        errorMessage = nil
        isLoading = true
        // Simulate async work
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.isLoading = false
        }
    }

    func verifyOTP() {
        errorMessage = nil
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.isLoading = false
            self.state.isAuthenticated = !self.state.otpCode.isEmpty
        }
    }

    func signInWithOAuth(provider: String) {
        errorMessage = nil
        isLoading = true
        state.authMethod = .oauth
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.isLoading = false
            self?.state.isAuthenticated = true
        }
    }

    func signOut() {
        state = AuthenticationState()
    }
}
