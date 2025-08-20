// ValidationHelper.swift

import Foundation


enum ValidationHelper {

    // Phone validation
    static func validatePhone(_ phone: String) -> Bool {
        let phoneRegex = "^[0-9]{8,15}$" // Basic: 8–15 digits
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
    }

    // Email validation
    static func validateEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    // Password validation (delegated to PasswordRules)
    static func validatePassword(_ password: String) -> Bool {
        let rules = PasswordRules.default
        return rules.validate(password)
    }

    // Name validation (letters + spaces, min 2 chars)
    static func validateName(_ name: String) -> Bool {
        let nameRegex = "^[A-Za-z ]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluate(with: name)
    }

    // File type validation (PDF, PPT, XLS, etc.)
    static func validateFileExtension(_ fileName: String, allowed: [String] = ["pdf", "ppt", "pptx", "xls", "xlsx"]) -> Bool {
        guard let ext = fileName.split(separator: ".").last?.lowercased() else { return false }
        return allowed.contains(ext)
    }

    // URL validation
    static func validateURL(_ urlString: String) -> Bool {
        return URL(string: urlString) != nil
    }
}

// MARK: - Password Rules
struct PasswordRules {
    let minLength: Int
    let requireUppercase: Bool
    let requireLowercase: Bool
    let requireDigit: Bool
    let requireSpecial: Bool

    func validate(_ password: String) -> Bool {
        guard password.count >= minLength else { return false }

        if requireUppercase && password.range(of: "[A-Z]", options: .regularExpression) == nil {
            return false
        }
        if requireLowercase && password.range(of: "[a-z]", options: .regularExpression) == nil {
            return false
        }
        if requireDigit && password.range(of: "[0-9]", options: .regularExpression) == nil {
            return false
        }
        if requireSpecial && password.range(of: "[^A-Za-z0-9]", options: .regularExpression) == nil {
            return false
        }
        return true
    }

    // Default rules (easily updateable in future)
    static var `default`: PasswordRules {
        PasswordRules(
            minLength: 8,
            requireUppercase: true,
            requireLowercase: true,
            requireDigit: true,
            requireSpecial: false // not required now, can enable later
        )
    }
}
