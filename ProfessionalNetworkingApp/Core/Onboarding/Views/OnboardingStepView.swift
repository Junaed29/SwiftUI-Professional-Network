//
//  OnboardingStepView.swift
//  ProfessionalNetworkingApp
//
//  Created by Junaed Chowdhury on 18/8/25.
//

import SwiftUI

struct OnboardingStepView: View {
    @Environment(\.appPalette) private var p
    var data: OnboardingDataModel

    var body: some View {
        VStack(spacing: AppTheme.Space.xl) {
            ThemedCard(style: .elevated) {
                LottieView(filename: data.lottieFile)
                    .frame(height: 280)
            }

            VStack(spacing: AppTheme.Space.sm) {
                Text(data.heading)
                    .styled(.title)
                    .multilineTextAlignment(.center)

                Text(data.text)
                    .styled(.body, color: p.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, AppTheme.Space.lg)
        .padding(.vertical, AppTheme.Space.lg)
        .contentShape(Rectangle())
    }
}

#Preview {
    OnboardingStepView(data: OnboardingDataModel.compactData.first!)
        .appTheme()
}
