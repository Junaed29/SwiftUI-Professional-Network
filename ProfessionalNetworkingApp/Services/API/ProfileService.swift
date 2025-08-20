// ProfileService.swift

import Foundation

protocol ProfileServiceProtocol {
    func fetchProfile(completion: @escaping (UserProfile?) -> Void)
    func saveProfile(_ profile: UserProfile, completion: @escaping (Bool) -> Void)
}

struct ProfileService: ProfileServiceProtocol {
    private let db = DatabaseManager()
    func fetchProfile(completion: @escaping (UserProfile?) -> Void) { db.fetchUserProfile(completion: completion) }
    func saveProfile(_ profile: UserProfile, completion: @escaping (Bool) -> Void) { db.saveUserProfile(profile, completion: completion) }
}
