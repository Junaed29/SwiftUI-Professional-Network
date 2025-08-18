// OAuthLoginView.swift

import SwiftUI

struct OAuthLoginView: View {
    @Environment(\.appPalette) private var p
    @StateObject private var viewModel = AuthenticationViewModel()

    var body: some View {
        ThemedScreen(usePadding: false, background: .gradient) {

                VStack(spacing: AppTheme.Space.lg) {
                    // Panel container
                    VStack(alignment: .leading, spacing: AppTheme.Space.lg) {
                        // Heading
                        VStack(alignment: .leading, spacing: AppTheme.Space.xs) {
                            Text("Welcome Back")
                                .styled(.largeTitle)
                            Text("Choose your preferred sign-in method")
                                .styled(.body, color: p.textSecondary)
                        }

                        Divider().overlay(p.primary).opacity(0.3)

                        // Gmail (outlined)
                        Button(action: { viewModel.signInWithOAuth(provider: "google") }) {
                            HStack(spacing: AppTheme.Space.md) {
                                Spacer()
                                BrandGlyph(name: "G")
                                Text("Sign in with Gmail").styled(.body)
                                Spacer()
                            }
                        }
                        .buttonStyle(OutlineButtonStyle())

                        // LinkedIn (filled primary)
                        Button(action: { viewModel.signInWithOAuth(provider: "linkedin") }) {
                            HStack(spacing: AppTheme.Space.md) {
                                Spacer()
                                BrandGlyph(name: "in")
                                    .foregroundColor(p.secondary)
                                Text("Sign in with LinkedIn")
                                    .bold()
                                    .styled(.body, color: p.secondary)
                                Spacer()
                            }
                        }
                        .background(p.primary)
                        .cornerRadius(AppTheme.Radius.md)
                        .buttonStyle(OutlineButtonStyle())

                        // OR divider
                        HStack(spacing: AppTheme.Space.md) {
                            Rectangle().fill(p.divider).frame(height: 1)
                            Text("OR").styled(.caption2, color: p.textSecondary)
                            Rectangle().fill(p.divider).frame(height: 1)
                        }

                        // Phone sign-in
                        NavigationLink(destination: PhoneLoginView()) {
                            HStack(spacing: AppTheme.Space.md) {
                                Spacer()
                                Image(systemName: "phone")
                                    .font(.body)
                                Text("Sign in with Phone").styled(.body)
                                Spacer()
                            }
                        }
                        .buttonStyle(OutlineButtonStyle())

                        Spacer()

                        // Legal text
                        (
                            Text("By continuing, you agree to our ").foregroundColor(p.textSecondary)
                            + Text("Terms of Service").foregroundColor(p.primary)
                            + Text(" and ").foregroundColor(p.textSecondary)
                            + Text("Privacy Policy").foregroundColor(p.primary)
                        )
                        .font(.caption2)
                        .frame(maxWidth: .infinity, alignment: .center)

                        // Bottom link
                        HStack(spacing: 6) {
                            Text("New to ConnectApp?").styled(.subheadline, color: p.textSecondary)
                            NavigationLink(destination: WelcomeView()) {
                                Text("Get Started").styled(.subheadline, color: p.primary)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, AppTheme.Space.xs)
                    }
                    .padding(AppTheme.Space.lg)
                    .padding(.horizontal, AppTheme.Space.lg)
                    .padding(.top, AppTheme.Space.lg)
                }
            }
        }
    
}

// MARK: - Small brand glyph
private struct BrandGlyph: View {
    @Environment(\.appPalette) private var p
    let name: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(p.bgAlt)
                .frame(width: 28, height: 28)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(p.divider, lineWidth: 1)
                )
            Text(name)
                .font(.footnote.weight(.semibold))
                .foregroundColor(p.textPrimary)
        }
    }
}

#Preview {
    NavigationStack { OAuthLoginView() }
        .appTheme()
}
