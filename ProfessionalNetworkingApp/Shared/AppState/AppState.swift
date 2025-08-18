//
//  AppState.swift
//  ProfessionalNetworkingApp
//
//  Created by Junaed Chowdhury on 18/8/25.
//


import SwiftUI

@Observable
@MainActor
final class AppState {
    private enum Keys {
        static let onboarding = "hasCompletedOnboarding"
        static let authed     = "isAuthenticated"
    }

    var hasCompletedOnboarding: Bool {
        didSet { UserDefaults.standard.set(hasCompletedOnboarding, forKey: Keys.onboarding) }
    }
    var isAuthenticated: Bool {
        didSet { UserDefaults.standard.set(isAuthenticated, forKey: Keys.authed) }
    }

    enum Flow: Hashable { case onboarding, auth, main }
    var currentFlow: Flow {
        if !hasCompletedOnboarding { return .onboarding }
        if !isAuthenticated        { return .auth }
        return .main
    }

    init(defaults: UserDefaults = .standard) {
        hasCompletedOnboarding = defaults.bool(forKey: Keys.onboarding)
        isAuthenticated        = defaults.bool(forKey: Keys.authed)
    }

    func completeOnboarding() { hasCompletedOnboarding = true }
    func loginSucceeded()     { isAuthenticated = true }
    func logout()             { isAuthenticated = false }
}
