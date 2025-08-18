// OTPVerificationView.swift

import SwiftUI

struct OTPVerificationView: View {
    @Environment(\.appPalette) private var p
    @State private var code: String = ""
    @State private var countdown: Int = 59
    @FocusState private var isFocused: Bool
    @StateObject private var viewModel = AuthenticationViewModel()

    // Optionally show the phone number that received the code
    var phoneDisplay: String? = nil

    // Timer for resend countdown
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ThemedScreen(usePadding: false, background: .gradient) {
            VStack(alignment: .center, spacing: AppTheme.Space.lg) {
                // Header: phone line
                if let phone = phoneDisplay ?? nonEmpty(viewModel.state.phoneNumber) {
                    Text(phone)
                        .styled(.subheadline, color: p.textSecondary)
                        .padding(.top, AppTheme.Space.lg)
                } else {
                    Text(" ") // maintain spacing if unknown
                        .styled(.subheadline, color: p.textSecondary)
                        .padding(.top, AppTheme.Space.lg)
                }

                // Title & subtitle
                VStack(spacing: AppTheme.Space.xs) {
                    Text("Verify Phone Number")
                        .styled(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, AppTheme.Space.lg)

                    Text("We've sent a 6-digit code to your phone.")
                        .styled(.body, color: p.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, AppTheme.Space.lg)
                }
                .padding(.top, AppTheme.Space.md)

                // Large icon
                ZStack {
                    Circle().fill(p.card.opacity(0.35)).frame(width: 180, height: 180)
                    Circle().fill(p.card.opacity(0.55)).frame(width: 120, height: 120)
                    Image(systemName: "envelope.badge")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(p.primary)
                        .frame(width: 56, height: 56)
                }
                .padding(.top, AppTheme.Space.lg)

                // OTP boxes + hidden field
                ZStack {
                    otpBoxes
                    // Hidden field that actually collects input
                    TextField("", text: $code)
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                        .focused($isFocused)
                        .frame(width: 1, height: 1)
                        .opacity(0.01)
                        .onChange(of: code) { _, newValue in
                            // Allow only digits, max 6
                            let digits = newValue.filter { $0.isNumber }
                            if digits.count > 6 {
                                code = String(digits.prefix(6))
                            } else if digits != newValue {
                                code = digits
                            }
                        }
                }
                .padding(.top, AppTheme.Space.md)
                .onTapGesture { isFocused = true }

                // Resend timer
                Text("Resend code in \(timeString(countdown))")
                    .styled(.caption2, color: p.textSecondary)
                    .padding(.top, AppTheme.Space.md)
                    .onReceive(timer) { _ in
                        if countdown > 0 { countdown -= 1 }
                    }

                Spacer()

                // Verify button
                Button(action: verify) {
                    Text(viewModel.isLoading ? "Verifying..." : "Verify")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(code.count < 6 || viewModel.isLoading)
                .padding(.horizontal, AppTheme.Space.lg)
                .padding(.bottom, AppTheme.Space.lg)
            }
        }
        .onAppear { isFocused = true }
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Subviews
    private var otpBoxes: some View {
        HStack(spacing: AppTheme.Space.md) {
            ForEach(0..<6, id: \.self) { index in
                let char = character(at: index)
                RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                    .stroke(borderColor(for: index), lineWidth: 1.5)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                            .fill(p.card)
                    )
                    .frame(width: 44, height: 56)
                    .overlay(
                        Text(char.map(String.init) ?? "")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(p.textPrimary)
                    )
            }
        }
        .padding(.horizontal, AppTheme.Space.lg)
    }

    // MARK: - Helpers
    private func character(at index: Int) -> Character? {
        guard index < code.count else { return nil }
        return Array(code)[index]
    }

    private func borderColor(for index: Int) -> Color {
        if index < code.count { return p.primary }
        return p.divider
    }

    private func timeString(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }

    private func nonEmpty(_ text: String?) -> String? {
        guard let t = text, !t.isEmpty else { return nil }
        return t
    }

    // MARK: - Actions
    private func verify() {
        viewModel.state.otpCode = code
        viewModel.verifyOTP()
    }
}

#Preview {
    NavigationStack {
        OTPVerificationView(phoneDisplay: "+1 (555) 123-4567")
    }
    .appTheme()
}
