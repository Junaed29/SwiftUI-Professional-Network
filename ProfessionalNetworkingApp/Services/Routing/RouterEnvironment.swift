//
//  RouterEnvironment.swift
//  ProfessionalNetworkingApp
//
//  Created by Junaed Chowdhury on 18/8/25.
//


import SwiftUI

/// Environment key to expose Router to any view.
private struct AppRouterKey: EnvironmentKey {
    static let defaultValue: Router = Router()
}

extension EnvironmentValues {
    var appRouter: Router {
        get { self[AppRouterKey.self] }
        set { self[AppRouterKey.self] = newValue }
    }
}

/// Provide a specific Router to a view subtree.
public struct ProvideRouter: ViewModifier {
    let router: Router
    public func body(content: Content) -> some View {
        content.environment(\.appRouter, router)
    }
}

extension View {
    func provideRouter(_ router: Router) -> some View {
        modifier(ProvideRouter(router: router))
    }
}
