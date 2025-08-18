//
//  Router.swift
//  ProfessionalNetworkingApp
//
//  Created by Junaed Chowdhury on 18/8/25.
//


import SwiftUI


@Observable
final class Router {
    /// Bind this to NavigationStack(path:)
    var path = NavigationPath()

    /// Optional parallel record of routes (useful for debugging / analytics / custom logic).
    /// Keep it in sync with `path`. If you don't need it, you can remove this and related lines.
    private(set) var routes: [Route] = []

    // MARK: - Push / Replace

    /// Push a new route on top of the stack
    func push(_ route: Route) {
        path.append(route)
        routes.append(route)
    }

    /// Replace the entire stack with a new root and optional following routes
    func setStack(_ newRoutes: [Route]) {
        var newPath = NavigationPath()
        for r in newRoutes { newPath.append(r) }
        path = newPath
        routes = newRoutes
    }

    // MARK: - Pop operations

    /// Go back one level in the navigation stack
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
        if !routes.isEmpty { routes.removeLast() }
    }

    /// Pop to a specific depth (keep exactly `depth` items on the stack).
    /// Example: depth=0 -> pop to root; depth=1 -> keep only the first screen.
    func popTo(depth: Int) {
        guard depth >= 0 else { return }
        let current = count
        guard current > depth else { return } // nothing to do if already shallower/equal
        let toRemove = current - depth
        path.removeLast(toRemove)
        if routes.count >= toRemove {
            routes.removeLast(toRemove)
        } else {
            routes.removeAll()
        }
    }

    // MARK: - Helpers

    /// Current stack depth (number of pushed destinations)
    var count: Int {
        // NavigationPath doesn’t expose count directly, so track via `routes`
        // If you remove `routes`, store count separately as you push/pop.
        routes.count
    }

    /// Clear everything back to an empty stack (root)
    func popToRoot() {
        popTo(depth: 0)
    }
}
