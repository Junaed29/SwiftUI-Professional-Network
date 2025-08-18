// OnboardingView.swift
//  ProfessionalNetworkingApp
//
//  Created by Junaed Chowdhury on 18/8/25.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.appPalette) private var p
    @Environment(\.appState) private var appState
    var data: [OnboardingDataModel]

    @State var slideGesture: CGSize = .zero
    @State var curSlideIndex = 0
    var distance: CGFloat = UIScreen.main.bounds.size.width

    func nextButton() {
        if curSlideIndex == data.count - 1 {
            appState.completeOnboarding()
            return
        }
        if curSlideIndex < data.count - 1 {
            withAnimation {
                curSlideIndex += 1
            }
        }
    }

    var body: some View {
        ThemedScreen(usePadding: false, background: .gradient) {
            ZStack(alignment: .center) {
                ForEach(data.indices, id: \.self) { i in
                    OnboardingStepView(data: data[i])
                        .offset(x: CGFloat(i) * distance)
                        .offset(x: slideGesture.width - CGFloat(curSlideIndex) * distance)
                        .animation(.spring(), value: curSlideIndex)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    slideGesture = value.translation
                                }
                                .onEnded { _ in
                                    if slideGesture.width < -50 {
                                        if curSlideIndex < data.count - 1 {
                                            withAnimation { curSlideIndex += 1 }
                                        }
                                    }
                                    if slideGesture.width > 50 {
                                        if curSlideIndex > 0 {
                                            withAnimation { curSlideIndex -= 1 }
                                        }
                                    }
                                    slideGesture = .zero
                                }
                        )
                }
            }

            VStack {
                Spacer()
                HStack(spacing: AppTheme.Space.lg) {
                    progressView()
                    Spacer()
                    Button(curSlideIndex == data.count - 1 ? "Done" : "Next", action: nextButton)
                        .buttonStyle(PrimaryButtonStyle())
                        .frame(width: 140)
                }
                .padding(.horizontal, AppTheme.Space.lg)
                .padding(.bottom, AppTheme.Space.lg)
            }

        }
        .appTheme()
    }

    func progressView() -> some View {
        HStack(spacing: AppTheme.Space.xs) {
            ForEach(data.indices, id: \.self) { i in
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(curSlideIndex >= i ? p.primary : p.divider)
                    .scaleEffect(curSlideIndex == i ? 1.2 : 1.0)
                    .animation(AppTheme.Motion.smooth, value: curSlideIndex)
            }
        }
    }
}

#Preview {
    OnboardingView(data: OnboardingDataModel.compactData)
        .appTheme()
}
