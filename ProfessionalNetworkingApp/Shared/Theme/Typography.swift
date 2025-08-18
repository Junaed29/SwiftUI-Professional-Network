// Typography.swift
// Text styles & modifiers
/*
Overview
- Centralizes typography choices for headings, body, captions, and section headers.

When to use
- Apply .styled(_:) to any Text to keep font and color consistent.
- Use .sectionHeader for subtle section titles, .largeTitle/.title for prominent headings.

Quick examples
  Text("Welcome").styled(.largeTitle)
  Text("Profile").styled(.title2)
  Text("Notes").styled(.caption, color: AppTheme.palette(.light).textSecondary)
  Text("Section").styled(.sectionHeader)
*/

import SwiftUI

/// Supported text styles used throughout the app.
public enum TextStyle {
    case largeTitle
    case title
    case title2
    case title3
    case headline
    case subheadline
    case body
    case callout
    case caption
    case caption2
    case footnote
    case sectionHeader
}

/// Applies a themed font and color to text content.
public struct ThemedText: ViewModifier {
    @Environment(\.colorScheme) private var scheme
    private let style: TextStyle
    private let color: Color?
    
    public init(_ style: TextStyle, color: Color? = nil) {
        self.style = style
        self.color = color
    }
    
    public func body(content: Content) -> some View {
        let p = AppTheme.palette(scheme)
        let textColor = color ?? p.textPrimary
        
        return content
            .font(fontForStyle(style))
            .foregroundColor(textColor)
    }
    
    private func fontForStyle(_ style: TextStyle) -> Font {
        switch style {
        case .largeTitle:
            return .largeTitle.weight(.bold)
        case .title:
            return .title.weight(.semibold)
        case .title2:
            return .title2.weight(.semibold)
        case .title3:
            return .title3.weight(.medium)
        case .headline:
            return .headline.weight(.semibold)
        case .subheadline:
            return .subheadline.weight(.medium)
        case .body:
            return .body
        case .callout:
            return .callout
        case .caption:
            return .caption.weight(.medium)
        case .caption2:
            return .caption2
        case .footnote:
            return .footnote
        case .sectionHeader:
            return .caption.weight(.semibold).uppercaseSmallCaps()
        }
    }
}

/// Convenience for applying ThemedText to any view that renders text.
public extension View {
    func styled(_ style: TextStyle, color: Color? = nil) -> some View {
        modifier(ThemedText(style, color: color))
    }
}
