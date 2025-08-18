// ThemedScreen.swift
// Screen-level wrapper
/*
Overview
- Provides a consistent screen background (solid, gradient, or custom) with optional horizontal padding.
- Centralizes background and spacing so individual screens stay lean.

When to use
- Wrap most top-level screens to apply the app background and consistent margins.
- Use background: .gradient for subtle visual depth or .custom for special cases.

Quick examples
  ThemedScreen {                       // solid app background, default padding
    VStack { /* content */ }
  }

  ThemedScreen(usePadding: false) {    // edge-to-edge content
    MapView()
  }

  ThemedScreen(background: .gradient) {
    FeedView()
  }

  ThemedScreen(background: .custom(.black)) {
    VideoPlayerView()
  }
*/

import SwiftUI

/// A reusable screen wrapper that applies app background and optional horizontal padding.
public struct ThemedScreen<Content: View>: View {
    @Environment(\.colorScheme) private var scheme
    private let content: () -> Content
    private let usePadding: Bool
    private let background: BackgroundType
    
    /// Background options for the screen.
    public enum BackgroundType {
        case solid
        case gradient
        case custom(Color)
    }
    
    /// Creates a ThemedScreen.
    /// - Parameters:
    ///   - usePadding: Whether to apply standard horizontal padding. Default is `true`.
    ///   - background: Solid, gradient, or custom color. Default is `.solid`.
    ///   - content: Screen content builder.
    public init(
        usePadding: Bool = true,
        background: BackgroundType = .solid,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.usePadding = usePadding
        self.background = background
        self.content = content
    }
    
    public var body: some View {
        let p = AppTheme.palette(scheme)
        
        ZStack {
            backgroundView(p).ignoresSafeArea()
            
            if usePadding {
                content()
                    .padding(.horizontal, AppTheme.Space.lg)
            } else {
                content()
            }
        }
    }
    
    @ViewBuilder
    private func backgroundView(_ p: AppTheme.Palette) -> some View {
        switch background {
        case .solid:
            p.bg
        case .gradient:
            LinearGradient(
                colors: [p.bg, p.bgAlt],
                startPoint: .top,
                endPoint: .bottom
            )
        case .custom(let color):
            color
        }
    }
}
