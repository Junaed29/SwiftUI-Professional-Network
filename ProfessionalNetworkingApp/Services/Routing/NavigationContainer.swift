//
//  NavigationContainer.swift
//  ProfessionalNetworkingApp
//
//  Created by Junaed Chowdhury on 18/8/25.
//

import SwiftUI

/// Hosts the NavigationStack and maps Route -> destination Views.
/// Keep this as the single place that knows which view corresponds to each Route.
struct NavigationContainer<Root: View>: View {
    @State private var router = Router()

    /// The initial/root content for this flow (e.g., Onboarding, Login, or Dashboard).
    let root: () -> Root

    init(@ViewBuilder root: @escaping () -> Root) {
        self.root = root
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            root()
                .navigationDestination(for: Route.self) { route in
                    destination(for: route)
                }
        }
        // Inject router so any child can call @Environment(\.appRouter).push(...)
        .provideRouter(router)
    }

    // Map each Route to a concrete destination view.
    @ViewBuilder
    private func destination(for route: Route) -> some View {
        switch route {
        case .welcome:
            WelcomeView()
        case .dashboard:
            HomeView()
        case .phoneLogin:
            PhoneLoginView()
        case .oAuthLogin:
            OAuthLoginView()
        case .otpVerification(phone: let phone):
            OTPVerificationView(phoneDisplay: phone)
        }
    }
}
