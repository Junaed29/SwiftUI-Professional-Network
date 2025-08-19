// UserCard.swift

import Foundation

struct UserCard: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let age: Int
    let location: String
    let tag: String
    let imageURL: URL?
    let photos: [URL]

    // Detail fields
    let bio: String
    let heightCM: Int?
    let weightKG: Int?
    let relationshipStatus: String?
    let ethnicity: String?
    let interests: [String]
    let lookingFor: [String]
    let friends: [URL]
}

enum SwipeAction { case like, pass }
