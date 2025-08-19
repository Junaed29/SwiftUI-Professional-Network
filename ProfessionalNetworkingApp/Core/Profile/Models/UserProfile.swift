//
//  UserProfile.swift
//  ProfessionalNetworkingApp
//
//  Created by Junaed Chowdhury on 19/8/25.
//


import Foundation

struct UserProfile: Identifiable, Codable, Equatable {
    var id: String = UUID().uuidString

    // Core
    var fullName: String = ""
    var age: Int? = nil
    var headline: String = ""
    var bio: String = ""
    var imageURL: URL? = nil
    var isVerified: Bool = false

    // Location
    var city: String? = nil
    var country: String? = nil

    // Basics
    var heightCM: Int? = nil
    var weightKG: Int? = nil
    var relationshipStatus: String? = nil
    var ethnicity: String? = nil

    // Social
    var friends: [Friend] = []

    // Interests and intent
    var interests: [String] = []
    var lookingFor: [String] = []
}

struct Friend: Identifiable, Codable, Equatable {
    var id: String = UUID().uuidString
    var name: String
    var avatarURL: URL?
}
