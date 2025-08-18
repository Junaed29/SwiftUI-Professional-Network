// ThemePreview.swift
// Preview & documentation
/*
Overview
- A live, interactive showcase of the theme tokens and components.
- Use it to review colors, typography, buttons, inputs, and components in one place.

When to use
- Run in Xcode previews or as a screen in a debug/dev build to validate theme changes.
- Share with designers to align on look & feel.

Quick usage
- From any file, open the preview canvas for ThemePreview to interact with it.
- Or embed in a NavigationStack and push/present it from a debug menu.

Notes
- Sections demonstrate how to apply AppTheme and the reusable UI components.
- Update this screen as your design system grows.
*/

import SwiftUI

public struct ThemePreview: View {
    @State private var textInput = ""
    @State private var isLoading = false
    
    public init() {}
    
    public var body: some View {
        ThemedScreen {
            ScrollView {
                VStack(spacing: AppTheme.Space.xl) {
                    // Colors Preview
                    colorPreviewSection
                    
                    // Typography Preview
                    typographyPreviewSection
                    
                    // Buttons Preview
                    buttonsPreviewSection
                    
                    // Components Preview
                    componentsPreviewSection
                    
                    // Text Fields Preview
                    textFieldsPreviewSection
                }
                .padding(.vertical, AppTheme.Space.lg)
            }
        }
        .navigationTitle("Theme Preview")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private var colorPreviewSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Space.md) {
            Text("Colors").styled(.headline)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: AppTheme.Space.sm) {
                ColorSwatch("Primary", AppTheme.palette(.light).primary)
                ColorSwatch("Success", AppTheme.palette(.light).success)
                ColorSwatch("Alert", AppTheme.palette(.light).alert)
                ColorSwatch("Warning", AppTheme.palette(.light).warning)
                ColorSwatch("Info", AppTheme.palette(.light).info)
                ColorSwatch("Card", AppTheme.palette(.light).card)
            }
        }
    }
    
    private var typographyPreviewSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Space.md) {
            Text("Typography").styled(.headline)
            
            ThemedCard {
                VStack(alignment: .leading, spacing: AppTheme.Space.sm) {
                    Text("Large Title").styled(.largeTitle)
                    Text("Title").styled(.title)
                    Text("Headline").styled(.headline)
                    Text("Body text for regular content").styled(.body)
                    Text("Caption for small details").styled(.caption)
                }
            }
        }
    }
    
    private var buttonsPreviewSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Space.md) {
            Text("Buttons").styled(.headline)
            
            VStack(spacing: AppTheme.Space.md) {
                Button("Primary Button") {}
                    .buttonStyle(PrimaryButtonStyle())
                
                Button("Outline Button") {}
                    .buttonStyle(OutlineButtonStyle())
                
                Button("Destructive Action") {}
                    .buttonStyle(DestructiveButtonStyle())
                
                HStack {
                    Button("Small") {}
                        .buttonStyle(SmallButtonStyle())
                    
                    Button("Another Small") {}
                        .buttonStyle(SmallButtonStyle())
                    
                    Spacer()
                }
            }
        }
    }
    
    private var componentsPreviewSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Space.md) {
            Text("Components").styled(.headline)
            
            // Status badges
            HStack {
                StatusBadge(.success, "Active")
                StatusBadge(.warning, "Pending")
                StatusBadge(.alert, "Error")
                StatusBadge(.info, "Info")
                Spacer()
            }
            
            // Cards
            ThemedCard(style: .elevated) {
                VStack(alignment: .leading, spacing: AppTheme.Space.sm) {
                    Text("Elevated Card").styled(.headline)
                    Text("This card has a subtle shadow").styled(.body)
                }
            }
            
            ThemedCard(style: .bordered) {
                Text("Bordered Card").styled(.body)
            }
        }
    }
    
    private var textFieldsPreviewSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Space.md) {
            Text("Text Fields").styled(.headline)
            
            VStack(spacing: AppTheme.Space.md) {
                TextField("Default field", text: $textInput)
                    .themedField()
                
                TextField("Search field", text: $textInput)
                    .themedField(style: .search)
                
                SecureField("Password", text: $textInput)
                    .themedField(style: .secure)
            }
        }
    }
}

// Helper for color preview
private struct ColorSwatch: View {
    @Environment(\.colorScheme) private var scheme
    let name: String
    let color: Color
    
    init(_ name: String, _ color: Color) {
        self.name = name
        self.color = color
    }
    
    var body: some View {
        VStack(spacing: AppTheme.Space.xs) {
            RoundedRectangle(cornerRadius: AppTheme.Radius.sm)
                .fill(color)
                .frame(height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.Radius.sm)
                        .stroke(AppTheme.palette(scheme).divider, lineWidth: 1)
                )
            
            Text(name)
                .styled(.caption2)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview("Light Mode") {
    NavigationStack {
        ThemePreview()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    NavigationStack {
        ThemePreview()
    }
    .preferredColorScheme(.dark)
}
