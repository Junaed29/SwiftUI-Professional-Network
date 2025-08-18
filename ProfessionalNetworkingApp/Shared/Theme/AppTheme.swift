// AppTheme.swift
// Core design tokens & palettes
/*
Overview
- Central place for design tokens: colors, spacing, motion, and radius.
- Use AppTheme.palette(_:) to get light/dark-aware colors.

When to use
- Any time you need a color, spacing, corner radius, or animation duration.
- Prefer these tokens over hard-coded values to ensure consistency.

Quick examples
- Colors:
  @Environment(\.colorScheme) var scheme
  let p = AppTheme.palette(scheme)
  Text("Hello").foregroundColor(p.textPrimary)
  RoundedRectangle(cornerRadius: AppTheme.Radius.md).fill(p.card)

- Spacing, radius, motion:
  VStack(spacing: AppTheme.Space.lg) { ... }
  .animation(AppTheme.Motion.smooth, value: state)
  .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.lg))

Notes
- Use Color(hex:) for additional palette entries if needed.
*/

import SwiftUI

/// Hex string to Color helper (e.g., "#1A365D").
// MARK: - Hex to Color
public extension Color {
    init(hex: String, alpha: Double = 1.0) {
        let cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        var value: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&value)
        let r = Double((value & 0xFF0000) >> 16) / 255.0
        let g = Double((value & 0x00FF00) >> 8) / 255.0
        let b = Double(value & 0x0000FF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}

/// App-wide theme tokens and palettes (light/dark aware).
// MARK: - Theme Tokens
public enum AppTheme {

    /// Resolved colors for the current color scheme.
    public struct Palette {
        public let primary: Color        // main brand (Navy/Blue)
        public let primaryAlt: Color     // secondary brand
        public let secondary: Color      // typically white
        public let success: Color        // green
        public let alert: Color          // red
        public let warning: Color        // orange/yellow
        public let info: Color           // blue
        public let textPrimary: Color
        public let textSecondary: Color
        public let bg: Color             // page background
        public let bgAlt: Color          // sections/cards background
        public let card: Color           // surfaces
        public let divider: Color        // strokes / separators
    }

    // Light (optimized for accessibility)
    public static let light = Palette(
        primary:       Color(hex: "#1A365D"),
        primaryAlt:    Color(hex: "#2B6CB0"),
        secondary:     Color(hex: "#FFFFFF"),
        success:       Color(hex: "#38A169"),
        alert:         Color(hex: "#E53E3E"),
        warning:       Color(hex: "#D69E2E"),
        info:          Color(hex: "#3182CE"),
        textPrimary:   Color(hex: "#2D3748"),
        textSecondary: Color(hex: "#718096"),
        bg:            Color(hex: "#F7FAFC"),
        bgAlt:         Color(hex: "#EDF2F7"),
        card:          Color.white,
        divider:       Color.black.opacity(0.08)
    )

    // Dark (harmonized)
    public static let dark = Palette(
        primary:       Color(hex: "#3182CE"),
        primaryAlt:    Color(hex: "#2B6CB0"),
        secondary:     Color(hex: "#FFFFFF"),
        success:       Color(hex: "#48BB78"),
        alert:         Color(hex: "#FC8181"),
        warning:       Color(hex: "#F6AD55"),
        info:          Color(hex: "#63B3ED"),
        textPrimary:   Color.white.opacity(0.92),
        textSecondary: Color.white.opacity(0.72),
        bg:            Color(hex: "#0E1623"),
        bgAlt:         Color(hex: "#1A202C"),
        card:          Color(hex: "#2D3748"),
        divider:       Color.white.opacity(0.12)
    )

    /// Picks the correct palette for current color scheme
    public static func palette(_ scheme: ColorScheme) -> Palette {
        scheme == .dark ? dark : light
    }

    // Spacing scale (consistent paddings)
    public enum Space {
        public static let xxxs: CGFloat = 2
        public static let xxs: CGFloat = 4
        public static let xs: CGFloat = 6
        public static let sm: CGFloat = 10
        public static let md: CGFloat = 14
        public static let lg: CGFloat = 18
        public static let xl: CGFloat = 24
        public static let xxl: CGFloat = 32
        public static let xxxl: CGFloat = 48
    }
    
    // Animation tokens
    public enum Motion {
        public static let quick = Animation.easeOut(duration: 0.15)
        public static let smooth = Animation.easeInOut(duration: 0.3)
        public static let bouncy = Animation.spring(response: 0.6, dampingFraction: 0.8)
    }
    
    // Corner radius scale
    public enum Radius {
        public static let sm: CGFloat = 8
        public static let md: CGFloat = 12
        public static let lg: CGFloat = 16
        public static let xl: CGFloat = 20
    }
}
