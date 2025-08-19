// AuthenticationModel.swift
// Defines authentication-related data structures

import Foundation

enum AuthMethod: String, Codable {
    case phone
    case oauth
}

struct AuthenticationState: Codable {
    var isAuthenticated: Bool = false
    var otpCodeSend: Bool = false
    var phoneNumber: String = ""
    var otpCode: String = ""
    var authMethod: AuthMethod? = nil
}
