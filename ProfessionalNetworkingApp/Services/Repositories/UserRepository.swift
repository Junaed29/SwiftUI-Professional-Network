// UserRepository.swift

import Foundation

final class UserRepository {
    private let profileService: ProfileServiceProtocol
    init(profileService: ProfileServiceProtocol = ProfileService()) { self.profileService = profileService }

    func getCurrentUser(completion: @escaping (UserProfile?) -> Void) {
        profileService.fetchProfile(completion: completion)
    }
}
