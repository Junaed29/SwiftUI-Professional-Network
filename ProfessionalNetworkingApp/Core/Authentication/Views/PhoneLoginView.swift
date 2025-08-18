// PhoneLoginView.swift

import SwiftUI

struct PhoneLoginView: View {
    @Environment(\.appPalette) private var p
    @State private var rawPhone: String = ""
    @State private var selectedCountry: CountryCode = .us
    @State private var showValidation: Bool = false
    @StateObject private var viewModel = AuthenticationViewModel()

    private var sanitizedDigits: String {
        rawPhone.filter { $0.isNumber }
    }
    private var isValid: Bool {
        ValidationHelper.validatePhone(sanitizedDigits)
    }
    private var formattedPlaceholder: String {
        switch selectedCountry {
        case .us: return "Phone number"
        default: return "Phone number"
        }
    }

    var body: some View {
        ThemedScreen(usePadding: false, background: .gradient) {
            ScrollView {
                VStack(spacing: AppTheme.Space.lg) {
                    // Title bar
                    Text("Phone Verification")
                        .styled(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, AppTheme.Space.lg)

                    // Illustration
                    RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                        .fill(p.card)
                        .frame(height: 140)
                        .overlay(
                            Image(systemName: "iphone.gen3")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(p.textSecondary)
                                .padding(36)
                        )
                        .padding(.horizontal, AppTheme.Space.lg)

                    // Panel
                    VStack(spacing: AppTheme.Space.lg) {
                        VStack(spacing: AppTheme.Space.xs) {
                            Text("Enter your phone number")
                                .styled(.title)
                                .multilineTextAlignment(.center)

                            Text("We'll send you a verification code")
                                .styled(.body, color: p.textSecondary)
                                .multilineTextAlignment(.center)
                        }

                        // Example neutral field (optional visual guide) - omitted to keep UI clean

                        // Live input field with validation state
                        VStack(alignment: .leading, spacing: AppTheme.Space.xs) {
                            phoneField(border: borderColor)
                            if showValidation && !isValid && !sanitizedDigits.isEmpty {
                                Text("Please enter a valid phone number.")
                                    .styled(.caption, color: p.alert)
                            }
                        }

                        // Action button
                        Button(action: sendCode) {
                            HStack {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: p.secondary))
                                }
                                Text(viewModel.isLoading ? "Sending..." : "Send Verification Code")
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .disabled(!isValid || viewModel.isLoading)

                        // Legal
                        legalText
                            .padding(.top, AppTheme.Space.sm)
                    }
                    .padding(.horizontal, AppTheme.Space.lg)
                    .padding(.vertical, AppTheme.Space.lg)
                    .cornerRadius(AppTheme.Radius.xl)
                    .padding(.horizontal, AppTheme.Space.lg)
                    .padding(.bottom, AppTheme.Space.lg)
                }
            }
        }
        .onChange(of: rawPhone) { _, _ in showValidation = true }
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Subviews
    private var borderColor: Color {
        guard showValidation else { return p.divider }
        if sanitizedDigits.isEmpty { return p.divider }
        return isValid ? p.success : p.alert
    }

    @ViewBuilder
    private func phoneField(border: Color) -> some View {
        HStack(spacing: AppTheme.Space.sm) {
            // Country menu
            Menu {
                Picker(selection: $selectedCountry) {
                    ForEach(CountryCode.allCases, id: \.self) { code in
                        Text("\(code.flag) \(code.display)  \(code.dial)")
                            .styled(.body, color: p.textSecondary)
                            .tag(code)
                    }
                } label: { EmptyView() }
            } label: {
                HStack(spacing: 6) {
                    Text(selectedCountry.flag)
                    Text(selectedCountry.dial)
                        .styled(.body, color: p.textPrimary)
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundColor(p.textSecondary)
                }
                .padding(.leading, AppTheme.Space.sm)
            }

            Divider()
                .frame(height: 24)
                .background(p.divider)

            // Phone input
            TextField(formattedPlaceholder, text: $rawPhone)
                .keyboardType(.phonePad)
                .textContentType(.telephoneNumber)
                .disableAutocorrection(true)
                .onTapGesture { showValidation = true }

            // Trailing check
            if isValid {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(p.success)
            }
        }
        .padding(AppTheme.Space.md)
        .background(p.card)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                .stroke(border, lineWidth: 1.5)
        )
        .cornerRadius(AppTheme.Radius.md)
    }

    private var legalText: some View {
        (
            Text("By continuing, you agree to our ").foregroundColor(p.textSecondary)
            + Text("Terms of Service").foregroundColor(p.primary)
            + Text(" and ").foregroundColor(p.textSecondary)
            + Text("Privacy Policy").foregroundColor(p.primary)
        )
        .font(.caption2)
    }

    // MARK: - Actions
    private func sendCode() {
        viewModel.state.phoneNumber = selectedCountry.dial + sanitizedDigits
        viewModel.state.authMethod = .phone
        viewModel.sendOTP()
    }
}

// MARK: - Country Code support (lightweight)
private enum CountryCode: CaseIterable {
    case us, gb, bd, `in`

    var flag: String {
        switch self {
        case .us: return "🇺🇸"
        case .gb: return "🇬🇧"
        case .bd: return "🇧🇩"
        case .`in`: return "🇮🇳"
        }
    }
    var display: String {
        switch self {
        case .us: return "United States"
        case .gb: return "United Kingdom"
        case .bd: return "Bangladesh"
        case .`in`: return "India"
        }
    }
    var dial: String {
        switch self {
        case .us: return "+1"
        case .gb: return "+44"
        case .bd: return "+880"
        case .`in`: return "+91"
        }
    }
}

#Preview {
    NavigationStack {
        PhoneLoginView()
    }
    .appTheme()
}
