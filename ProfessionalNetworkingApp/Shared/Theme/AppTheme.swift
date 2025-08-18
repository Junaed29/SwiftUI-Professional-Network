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

    // MARK: - Light Palette
    public static let light = Palette(
        primary:       Color(hex: "#2563EB"), // Vibrant blue
        primaryAlt:    Color(hex: "#1D4ED8"), // Darker variant
        secondary:     Color(hex: "#06B6D4"), // Teal accent
        success:       Color(hex: "#22C55E"), // Softer green
        alert:         Color(hex: "#EF4444"), // Clean red
        warning:       Color(hex: "#F59E0B"), // Amber / gold
        info:          Color(hex: "#3B82F6"), // Friendly info blue
        textPrimary:   Color(hex: "#111827"), // Near-black gray
        textSecondary: Color(hex: "#6B7280"), // Muted gray
        bg:            Color(hex: "#F9FAFB"), // Light background
        bgAlt:         Color(hex: "#F3F4F6"), // Slightly darker alt
        card:          Color.white,           // Cards stay white
        divider:       Color.black.opacity(0.08)
    )

    // MARK: - Dark Palette
    public static let dark = Palette(
        primary:       Color(hex: "#3B82F6"), // Lighter blue for dark bg
        primaryAlt:    Color(hex: "#2563EB"), // Base blue accent
        secondary:     Color(hex: "#06B6D4"), // Teal still works well
        success:       Color(hex: "#22C55E"), // Same green (accessible)
        alert:         Color(hex: "#F87171"), // Softer red in dark mode
        warning:       Color(hex: "#FBBF24"), // Lighter amber for dark mode
        info:          Color(hex: "#60A5FA"), // Brighter info blue
        textPrimary:   Color.white.opacity(0.92), // Strong readable white
        textSecondary: Color.white.opacity(0.72), // Muted gray-white
        bg:            Color(hex: "#0F172A"),     // Deep navy/charcoal
        bgAlt:         Color(hex: "#1E293B"),     // Slightly lighter alt
        card:          Color(hex: "#111827"),     // Dark card
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
