//
//  ThemedCard.swift
//  ProfessionalNetworkingApp
//
//  Created by Junaed Chowdhury on 19/8/25.
//
/*
Overview
- Small, reusable UI pieces built on top of AppTheme (cards, badges, loading, empty states).

When to use
- ThemedCard: wrap content on a surface (default/subtle/elevated/bordered).


Quick examples
  ThemedCard(style: .elevated) {
    Text("Profile").styled(.headline)
  }

*/

import SwiftUI

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
