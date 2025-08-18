// TextFieldStyles.swift
// Input field styling
/*
Overview
- Consistent styling for text inputs with default, search, and secure variants.

When to use
- Apply .themedField(style:) to TextField or SecureField to match app look and feel.
- Use .search for inputs with a search icon; .secure for password fields.

Quick examples
  @State var query = ""
  TextField("Search", text: $query)
    .themedField(style: .search)

  @State var email = ""
  TextField("Email", text: $email)
    .themedField()

  @State var password = ""
  SecureField("Password", text: $password)
    .themedField(style: .secure)
*/

import SwiftUI

/// Styles available for themed text fields.
public enum TextFieldStyleType {
    case `default`
    case search
    case secure
}

/// Modifier that applies the app's themed input style.
public struct ThemedTextField: ViewModifier {
    @Environment(\.colorScheme) private var scheme
    private let style: TextFieldStyleType
    
    public init(style: TextFieldStyleType = .default) {
        self.style = style
    }
    
    public func body(content: Content) -> some View {
        let p = AppTheme.palette(scheme)
        
        HStack {
            if style == .search {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(p.textSecondary)
                    .font(.system(.body, weight: .medium))
            }
            
            content
                .font(.system(.body, design: .rounded))
                .foregroundColor(p.textPrimary)
        }
        .padding(AppTheme.Space.md)
        .background(p.card)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                .stroke(p.divider, lineWidth: 1)
        )
        .cornerRadius(AppTheme.Radius.md)
    }
}

/// Convenience to apply the themed input modifier.
public extension View {
    func themedField(style: TextFieldStyleType = .default) -> some View {
        modifier(ThemedTextField(style: style))
    }
}
