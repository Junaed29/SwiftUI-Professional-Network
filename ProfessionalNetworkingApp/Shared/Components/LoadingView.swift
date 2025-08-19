// LoadingView.swift

import SwiftUI
/*
Overview
- Small, reusable UI pieces built on top of AppTheme (cards, badges, loading, empty states).

When to use
- ThemedLoadingView: full-screen loading state matching the theme.

Quick examples
  ThemedLoadingView(message: "Syncing...")
*/

/// Full-screen themed loading state.
public struct ThemedLoadingView: View {
    @Environment(\.colorScheme) private var scheme
    private let message: String

    public init(message: String = "Loading...") {
        self.message = message
    }

    public var body: some View {
        let p = AppTheme.palette(scheme)

        VStack(spacing: AppTheme.Space.lg) {
            ProgressView()
                .scaleEffect(1.2)
                .progressViewStyle(CircularProgressViewStyle(tint: p.primary))

            Text(message)
                .styled(.body, color: p.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(p.bg)
    }
}


#Preview { ThemedLoadingView() }
