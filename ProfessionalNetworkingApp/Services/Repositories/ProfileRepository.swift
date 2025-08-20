// ProfileRepository.swift

import Foundation

final class ProfileRepository {
    private let service: ProfileServiceProtocol
    init(service: ProfileServiceProtocol = ProfileService()) { self.service = service }

    func save(_ profile: UserProfile, completion: @escaping (Bool) -> Void) {
        service.saveProfile(profile, completion: completion)
    }
}
