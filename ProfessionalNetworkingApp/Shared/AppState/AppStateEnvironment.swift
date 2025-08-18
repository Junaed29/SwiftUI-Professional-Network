//
//  AppStateEnvironment.swift
//  ProfessionalNetworkingApp
//
//  Created by Junaed Chowdhury on 18/8/25.
//


import SwiftUI

private struct AppStateKey: EnvironmentKey {
    static var defaultValue: AppState {
            MainActor.assumeIsolated { AppState() }
        }
}

extension EnvironmentValues {
    var appState: AppState {
        get { self[AppStateKey.self] }
        set { self[AppStateKey.self] = newValue }
    }
}

/// View modifier to provide AppState to subtree.
struct ProvideAppState: ViewModifier {
    let appState: AppState
    public func body(content: Content) -> some View {
        content.environment(\.appState, appState)
    }
}

extension View {
    func provideAppState(_ appState: AppState) -> some View {
        modifier(ProvideAppState(appState: appState))
    }
}
