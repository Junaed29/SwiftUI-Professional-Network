//
//  ChipView.swift
//  ProfessionalNetworkingApp
//
//  Created by Junaed Chowdhury on 19/8/25.
//


//
//  ChipView.swift
//  ProfessionalNetworkingApp
//
//  Created by Junaed Chowdhury on 19/8/25.
//

import SwiftUI

struct ChipView: View {
    let text: String
    var background: Color = .gray.opacity(0.15)
    var textColor: Color = .primary
    var systemIcon: String? = nil
    
    var body: some View {
        HStack(spacing: 6) {
            if let systemIcon = systemIcon {
                Image(systemName: systemIcon)
                    .font(.system(size: 12, weight: .semibold))
            }
            Text(text)
                .font(.subheadline.weight(.medium))
        }
        .foregroundColor(textColor)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(background)
        )
    }
}

#Preview {
    VStack(spacing: 12) {
        ChipView(text: "iOS Developer", background: .blue.opacity(0.15), textColor: .blue)
        ChipView(text: "Nearby", background: .green.opacity(0.15), textColor: .green, systemIcon: "mappin.and.ellipse")
        ChipView(text: "Premium", background: .yellow.opacity(0.15), textColor: .yellow, systemIcon: "star.fill")
    }
    .padding()
}
