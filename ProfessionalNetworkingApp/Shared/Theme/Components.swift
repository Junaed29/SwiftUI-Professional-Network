// Components.swift
// Common UI components
/*
Overview
- Small, reusable UI pieces built on top of AppTheme (cards, badges, loading, empty states).

When to use
- ThemedCard: wrap content on a surface (default/subtle/elevated/bordered).
- StatusBadge: show small status labels (success/alert/warning/info/neutral).
- LoadingButton: trigger async actions with a built-in spinner.
- EmptyStateView: friendly placeholder for empty/error views.
- ThemedLoadingView: full-screen loading state matching the theme.

Quick examples
  ThemedCard(style: .elevated) {
    Text("Profile").styled(.headline)
  }

  HStack { StatusBadge(.success, "Active"); StatusBadge(.warning, "Pending") }

  LoadingButton("Save") {
    await viewModel.save()
  }
  .buttonStyle(PrimaryButtonStyle())

  EmptyStateView(icon: "tray",
                 title: "No Items",
                 message: "Try adding a new item",
                 actionTitle: "Add",
                 action: { showingAdd = true })

  ThemedLoadingView(message: "Syncing...")
*/

import SwiftUI

// MARK: - Card Styles
/// Card style variants for ThemedCard.
public enum CardStyle {
    case `default`
    case subtle
    case elevated
    case bordered
}

/// Theme-aware card container with multiple style variants.
public struct ThemedCard<Content: View>: View {
    @Environment(\.colorScheme) private var scheme
    private let style: CardStyle
    private let content: () -> Content
    
    public init(style: CardStyle = .default, @ViewBuilder content: @escaping () -> Content) {
        self.style = style
        self.content = content
    }
    
    public var body: some View {
        let p = AppTheme.palette(scheme)
        
        content()
            .padding(AppTheme.Space.lg)
            .background(cardBackground(p))
            .overlay(cardOverlay(p))
            .cornerRadius(AppTheme.Radius.lg)
    }
    
    @ViewBuilder
    private func cardBackground(_ p: AppTheme.Palette) -> some View {
        switch style {
        case .default:
            p.card
        case .subtle:
            p.bgAlt
        case .elevated:
            p.card
        case .bordered:
            Color.clear
        }
    }
    
    @ViewBuilder
    private func cardOverlay(_ p: AppTheme.Palette) -> some View {
        switch style {
        case .bordered:
            RoundedRectangle(cornerRadius: AppTheme.Radius.lg)
                .stroke(p.divider, lineWidth: 1)
        case .elevated:
            RoundedRectangle(cornerRadius: AppTheme.Radius.lg)
                .shadow(color: p.textPrimary.opacity(0.08), radius: 8, x: 0, y: 4)
                .foregroundColor(.clear)
        default:
            EmptyView()
        }
    }
}

// MARK: - Status Badge
/// Small, colored badge for labeling statuses.
public enum StatusType {
    case success
    case alert
    case warning
    case info
    case neutral
}

/// Theme-aware status badge with semantic colors.
public struct StatusBadge: View {
    @Environment(\.colorScheme) private var scheme
    private let type: StatusType
    private let text: String
    
    public init(_ type: StatusType, _ text: String) {
        self.type = type
        self.text = text
    }
    
    public var body: some View {
        let p = AppTheme.palette(scheme)
        
        Text(text)
            .font(.caption.weight(.semibold))
            .foregroundColor(badgeTextColor(p))
            .padding(.horizontal, AppTheme.Space.sm)
            .padding(.vertical, AppTheme.Space.xs)
            .background(badgeBackground(p))
            .cornerRadius(AppTheme.Radius.sm)
    }
    
    private func badgeBackground(_ p: AppTheme.Palette) -> Color {
        switch type {
        case .success: return p.success.opacity(0.15)
        case .alert: return p.alert.opacity(0.15)
        case .warning: return p.warning.opacity(0.15)
        case .info: return p.info.opacity(0.15)
        case .neutral: return p.textSecondary.opacity(0.15)
        }
    }
    
    private func badgeTextColor(_ p: AppTheme.Palette) -> Color {
        switch type {
        case .success: return p.success
        case .alert: return p.alert
        case .warning: return p.warning
        case .info: return p.info
        case .neutral: return p.textSecondary
        }
    }
}

// MARK: - Loading Button
/// Button that runs an async action and shows a spinner while waiting.
public struct LoadingButton<Label: View>: View {
    @Environment(\.colorScheme) private var scheme
    private let action: () async -> Void
    private let label: () -> Label
    @State private var isLoading = false
    
    public init(action: @escaping () async -> Void, @ViewBuilder label: @escaping () -> Label) {
        self.action = action
        self.label = label
    }
    
    public var body: some View {
        Button {
            Task {
                isLoading = true
                await action()
                isLoading = false
            }
        } label: {
            HStack(spacing: AppTheme.Space.sm) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.palette(scheme).secondary))
                } else {
                    label()
                }
            }
        }
        .disabled(isLoading)
    }
}

/// Convenience initializer for text-only loading buttons.
public extension LoadingButton where Label == Text {
    init(_ title: String, action: @escaping () async -> Void) {
        self.init(action: action) {
            Text(title)
        }
    }
}

// MARK: - Empty State
/// Friendly placeholder for empty lists or error states.
public struct EmptyStateView: View {
    @Environment(\.colorScheme) private var scheme
    private let icon: String
    private let title: String
    private let message: String
    private let actionTitle: String?
    private let action: (() -> Void)?
    
    public init(
        icon: String,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
    
    public var body: some View {
        let p = AppTheme.palette(scheme)
        
        VStack(spacing: AppTheme.Space.lg) {
            Image(systemName: icon)
                .font(.system(size: 48, weight: .medium))
                .foregroundColor(p.textSecondary)
            
            VStack(spacing: AppTheme.Space.sm) {
                Text(title)
                    .styled(.headline)
                
                Text(message)
                    .styled(.body, color: p.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            if let actionTitle = actionTitle, let action = action {
                Button(actionTitle, action: action)
                    .buttonStyle(OutlineButtonStyle())
                    .frame(maxWidth: 200)
            }
        }
        .padding(AppTheme.Space.xl)
    }
}

// MARK: - Loading View (theme-aware full-screen)
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
