//
//  ExpandableText.swift
//  ProfessionalNetworkingApp
//
//  Created by Junaed Chowdhury on 20/8/25.
//
//
//  A reusable text block that truncates to N lines and shows
//  a "Show more / Show less" toggle only when needed.
//  It measures limited vs full height using hidden twins + PreferenceKeys,
//  exactly like your current approach, but encapsulated.
//
//  Usage:
//    ExpandableText(profile.bio)                     // defaults to 3 lines
//    ExpandableText(profile.bio, lineLimit: 2)
//      .textStyle(.body)
//      .textColor(p.textSecondary)
//
//  Place in: Shared/Components/ExpandableText.swift
//

import SwiftUI

public struct ExpandableText: View {
    // MARK: - Environment / Theme
    @Environment(\.appPalette) private var p

    // MARK: - Public API
    private let text: String
    private let lineLimit: Int
    private let moreLabel: String
    private let lessLabel: String

    // Optional style modifiers (fluent)
    private var _textStyle: AppTextStyle = .body // if you use your `.styled` helper
    private var _textColor: Color? = nil

    // MARK: - Internal state
    @State private var expanded = false
    @State private var fullHeight: CGFloat = 0
    @State private var limitedHeight: CGFloat = 0

    // MARK: - Init
    public init(
        _ text: String,
        lineLimit: Int = 3,
        moreLabel: String = "Show more",
        lessLabel: String = "Show less"
    ) {
        self.text = text
        self.lineLimit = lineLimit
        self.moreLabel = moreLabel
        self.lessLabel = lessLabel
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Space.sm) {
            // Visible text
            Text(text)
                .styled(_textStyle, color: _textColor ?? p.textSecondary)
                .lineLimit(expanded ? nil : lineLimit)
                // Hidden limited twin (measures N-line height)
                .background(
                    Text(text)
                        .styled(_textStyle, color: _textColor ?? p.textSecondary)
                        .lineLimit(lineLimit)
                        .fixedSize(horizontal: false, vertical: true)
                        .background(
                            GeometryReader { geo in
                                Color.clear.preference(key: LimitedTextHeightKey.self, value: geo.size.height)
                            }
                        )
                        .hidden()
                )
                // Hidden full twin (measures full height)
                .overlay(
                    Text(text)
                        .styled(_textStyle, color: _textColor ?? p.textSecondary)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .background(
                            GeometryReader { geo in
                                Color.clear.preference(key: FullTextHeightKey.self, value: geo.size.height)
                            }
                        )
                        .hidden()
                )
                .onPreferenceChange(LimitedTextHeightKey.self) { limitedHeight in
                    limitedHeight.map { limitedHeight in self.limitedHeight = limitedHeight }
                }
                .onPreferenceChange(FullTextHeightKey.self) { fullHeight in
                    fullHeight.map { fullHeight in self.fullHeight = fullHeight }
                }

            // Toggle appears only if there is truncation
            if fullHeight > (limitedHeight + 1) {
                Button(action: { withAnimation(.easeInOut) { expanded.toggle() } }) {
                    Text(expanded ? lessLabel : moreLabel)
                        .styled(.caption, color: p.primary)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - Preference keys
private struct FullTextHeightKey: PreferenceKey {
    static var defaultValue: CGFloat? = nil
    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        if let next = nextValue() { value = max(value ?? 0, next) }
    }
}
private struct LimitedTextHeightKey: PreferenceKey {
    static var defaultValue: CGFloat? = nil
    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        if let next = nextValue() { value = max(value ?? 0, next) }
    }
}

// MARK: - Fluent styling (optional)
public extension ExpandableText {
    /// Apply your app's text style (hooks into your `.styled` helper).
    func textStyle(_ style: AppTextStyle) -> Self {
        var copy = self; copy._textStyle = style; return copy
    }

    /// Override the text color (defaults to palette.secondary text).
    func textColor(_ color: Color) -> Self {
        var copy = self; copy._textColor = color; return copy
    }
}
