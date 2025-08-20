// AuthService.swift

import Foundation

protocol AuthServiceProtocol {
    func sendOTP(to phone: String, completion: @escaping (Bool) -> Void)
    func verifyOTP(_ code: String, completion: @escaping (Bool) -> Void)
}

struct AuthService: AuthServiceProtocol {
    private let manager = AuthenticationManager()
    func sendOTP(to phone: String, completion: @escaping (Bool) -> Void) { manager.sendOTP(to: phone, completion: completion) }
    func verifyOTP(_ code: String, completion: @escaping (Bool) -> Void) { manager.verifyOTP(code, completion: completion) }
}
