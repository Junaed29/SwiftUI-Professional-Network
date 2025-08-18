// ButtonStyles.swift
// Reusable button styles
/*
Overview
- A set of consistent, accessible button styles for primary, outline, destructive, and small buttons.

When to use
- Use PrimaryButtonStyle for main call-to-actions.
- Use OutlineButtonStyle for secondary actions on emphasized surfaces.
- Use DestructiveButtonStyle for destructive/irreversible actions.
- Use SmallButtonStyle for compact inline actions.

Quick examples
  Button("Continue") { /* action */ }
    .buttonStyle(PrimaryButtonStyle())

  Button("Edit") { }
    .buttonStyle(OutlineButtonStyle())

  Button("Delete") { }
    .buttonStyle(DestructiveButtonStyle())

  HStack {
    Button("Add") { }.buttonStyle(SmallButtonStyle())
    Button("Share") { }.buttonStyle(SmallButtonStyle())
  }
*/

import SwiftUI

/// Primary filled button for the main call to action.
public struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var scheme
    @Environment(\.isEnabled) private var isEnabled
    
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        let p = AppTheme.palette(scheme)
        return configuration.label
            .font(.system(.headline, design: .rounded))
            .foregroundColor(p.secondary)
            .padding(.vertical, AppTheme.Space.md)
            .frame(maxWidth: .infinity)
            .background(isEnabled ? p.primary : p.textSecondary)
            .cornerRadius(AppTheme.Radius.md)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(AppTheme.Motion.quick, value: configuration.isPressed)
    }
}

/// Outlined button for secondary actions.
public struct OutlineButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var scheme
    @Environment(\.isEnabled) private var isEnabled
    
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        let p = AppTheme.palette(scheme)
        let borderColor = isEnabled ? p.primary : p.textSecondary
        let textColor = isEnabled ? p.primary : p.textSecondary
        
        return configuration.label
            .font(.system(.headline, design: .rounded))
            .foregroundColor(textColor)
            .padding(.vertical, AppTheme.Space.md)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                    .fill(configuration.isPressed ? p.primary.opacity(0.1) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                    .stroke(borderColor, lineWidth: 1.5)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(AppTheme.Motion.quick, value: configuration.isPressed)
    }
}

/// Destructive filled button for irreversible actions.
public struct DestructiveButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var scheme
    @Environment(\.isEnabled) private var isEnabled
    
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        let p = AppTheme.palette(scheme)
        return configuration.label
            .font(.system(.headline, design: .rounded))
            .foregroundColor(p.secondary)
            .padding(.vertical, AppTheme.Space.md)
            .frame(maxWidth: .infinity)
            .background(isEnabled ? p.alert : p.textSecondary)
            .cornerRadius(AppTheme.Radius.md)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(AppTheme.Motion.quick, value: configuration.isPressed)
    }
}

/// Compact button for inline or dense UI.
public struct SmallButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var scheme
    
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        let p = AppTheme.palette(scheme)
        return configuration.label
            .font(.system(.subheadline, design: .rounded))
            .fontWeight(.medium)
            .foregroundColor(p.secondary)
            .padding(.horizontal, AppTheme.Space.md)
            .padding(.vertical, AppTheme.Space.sm)
            .background(p.primary)
            .cornerRadius(AppTheme.Radius.sm)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(AppTheme.Motion.quick, value: configuration.isPressed)
    }
}
