// AuthenticationManager.swift

import Foundation

final class AuthenticationManager {
    func sendOTP(to phone: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) { completion(true) }
    }
    func verifyOTP(_ code: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) { completion(!code.isEmpty) }
    }
}
