// DatabaseManager.swift

import Foundation

final class DatabaseManager {
    func fetchUserProfile(completion: @escaping (UserProfile?) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) { completion(UserProfile(fullName: "Sample")) }
    }
    func saveUserProfile(_ profile: UserProfile, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) { completion(true) }
    }
}
