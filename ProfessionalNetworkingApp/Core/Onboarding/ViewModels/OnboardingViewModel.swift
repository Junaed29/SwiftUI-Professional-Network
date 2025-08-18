// OnboardingViewModel.swift

import Foundation
import Observation


@Observable
final class OnboardingViewModel {

    // MARK: - UI States
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var isOnboarded: Bool = false

    // MARK: - Future API Hook
    /// Entry point for future API integration
    func performOnboarding(with credentials: [String: Any]) async {
        isLoading = true
        errorMessage = nil

        do {
            //  Placeholder for future API call
            let result = try await mockOnboardingAPI(credentials: credentials)

            // ✅ Success
            isOnboarded = result
        } catch {
            // ❌ Failure
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Mock API (replace with real endpoint later)
    private func mockOnboardingAPI(credentials: [String: Any]) async throws -> Bool {
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1s delay

        // Simulate success/failure
        if Bool.random() {
            return true
        } else {
            throw URLError(.badServerResponse)
        }
    }
}
