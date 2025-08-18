//
//  AppRoot.swift
//  ProfessionalNetworkingApp
//
//  Created by Junaed Chowdhury on 18/8/25.
//

import SwiftUI

/// Chooses the active flow based on AppState flags and mounts a fresh NavigationContainer per flow.
/// `.id(appState.currentFlow)` forces recreation when the flow flips, resetting each stack cleanly.
struct AppRoot: View {
    @State private var appState = AppState()
    let onBoardingData = OnboardingDataModel.compactData

    var body: some View {
        Group {
            switch appState.currentFlow {
            case .onboarding:
                NavigationContainer { OnboardingView(data: OnboardingDataModel.compactData) }

            case .auth:
                NavigationContainer { WelcomeView() } // or LoginView()

            case .main:
                NavigationContainer { HomeView() }
            }
        }
        .id(appState.currentFlow)
        .provideAppState(appState)
        .appTheme()      
    }
}
