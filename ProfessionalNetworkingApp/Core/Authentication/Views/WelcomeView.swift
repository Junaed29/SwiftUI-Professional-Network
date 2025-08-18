// WelcomeView.swift

import SwiftUI

struct WelcomeView: View {
    @Environment(\.appPalette) private var p
    @Environment(\.appRouter) private var router

    var body: some View {
        ThemedScreen(usePadding: false, background: .gradient) {
            VStack(spacing: 0) {
                Spacer(minLength: 0)

                // Hero illustration (Lottie)
                LottieView(filename: "network_connections_minimal")
                    .frame(height: 260)
                    .padding(.bottom, AppTheme.Space.lg)

                // Bottom sheet panel
                VStack(spacing: AppTheme.Space.md) {
                    Text("Connect Professionally")
                        .styled(.title)
                        .multilineTextAlignment(.center)

                    Text("Build meaningful business relationships")
                        .styled(.body, color: p.textSecondary)
                        .multilineTextAlignment(.center)

                    NavigationLink(destination: PhoneLoginView()) {
                        Text("Get Started")
                    }
                    .buttonStyle(PrimaryButtonStyle())

                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .styled(.caption2, color: p.textSecondary)

                        Button {
                            router.push(.dashboard)
                        } label: {
                            Text("Sign In")
                                .styled(.caption2, color: p.primary)
                        }


                    }
                    .padding(.top, AppTheme.Space.xs)
                }
                .padding(.horizontal, AppTheme.Space.lg)
                .padding(.top, AppTheme.Space.xl)
                .padding(.bottom, AppTheme.Space.lg)
                .frame(maxWidth: .infinity)
                .cornerRadius(AppTheme.Radius.xl, corners: [.topLeft, .topRight])
            }
        }
    }
}

#Preview {
    WelcomeView()
        .appTheme()
}
