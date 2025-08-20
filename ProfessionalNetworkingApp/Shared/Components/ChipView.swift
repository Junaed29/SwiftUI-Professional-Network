//
//  ChipView.swift
//  ProfessionalNetworkingApp
//
//  Created by Junaed Chowdhury on 19/8/25.
//

import SwiftUI

struct ChipView: View {
    @Environment(\.appPalette) private var p
    let text: String
    // Optional overrides; if nil, resolve from palette
    var background: Color? = nil
    var textColor: Color? = nil
    var systemIcon: String? = nil
    var outline: Bool = false

    var body: some View {
        let fg = textColor ?? p.textPrimary
        let bg = background ?? p.bgAlt.opacity(0.15)

        HStack(spacing: 6) {
            if let systemIcon = systemIcon {
                Image(systemName: systemIcon)
                    .font(.system(size: 12, weight: .semibold))
            }
            Text(text)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                
        }
        .foregroundColor(fg)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(outline ? Color.clear : bg)
        )
        .overlay(
            Capsule()
                .stroke(outline ? p.divider : Color.clear, lineWidth: 1)
        )
    }
}

#Preview {
    VStack(spacing: 12) {
        ChipView(text: "Android Developer")
        ChipView(text: "iOS Developer", background: Color.blue.opacity(0.15), textColor: .blue)
        ChipView(text: "Nearby", background: Color.green.opacity(0.15), textColor: .green, systemIcon: "mappin.and.ellipse")
        ChipView(text: "Premium", background: Color.yellow.opacity(0.15), textColor: .yellow, systemIcon: "star.fill")
        ChipView(text: "Outline", outline: true)
    }
    .padding()
}
