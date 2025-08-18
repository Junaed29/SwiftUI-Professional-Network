// AppPaletteEnvironment.swift
// Environment-driven access to AppTheme.Palette
/*
Overview
- Exposes the resolved AppTheme.Palette via SwiftUI's Environment for convenient access.
- Add `.appTheme()` at a suitable root (e.g., root view, feature containers) to provide the palette.

Why
- Avoid recomputing `AppTheme.palette(colorScheme)` in each view.
- Make themed colors available as `@Environment(\.appPalette)` anywhere in the subtree.

Quick usage
  struct RootView: View {
    var body: some View {
      ContentView()
        .appTheme() // injects the correct palette for the current ColorScheme
    }
  }

  struct Example: View {
    @Environment(\.appPalette) private var p
    var body: some View {
      Text("Hello").foregroundColor(p.textPrimary)
      RoundedRectangle(cornerRadius: AppTheme.Radius.md).fill(p.card)
    }
  }

Notes
- `.appTheme()` resolves the palette for the current ColorScheme; changing the scheme updates the palette automatically.
- This complements ThemedScreen and other Theme components.
*/

import SwiftUI

// 1) Environment key to store the palette
private struct AppPaletteKey: EnvironmentKey {
    static let defaultValue: AppTheme.Palette = AppTheme.light
}

// 2) Convenience accessor
public extension EnvironmentValues {
    var appPalette: AppTheme.Palette {
        get { self[AppPaletteKey.self] }
        set { self[AppPaletteKey.self] = newValue }
    }
}

// 3) Modifier that resolves the right palette for current color scheme
public struct ApplyAppTheme: ViewModifier {
    @Environment(\.colorScheme) private var scheme
    public func body(content: Content) -> some View {
        content.environment(\.appPalette, AppTheme.palette(scheme))
    }
}

// 4) Easy-to-use entry point
public extension View {
    func appTheme() -> some View { modifier(ApplyAppTheme()) }
}
