// Core/Profile/ViewModels/ProfileViewModel.swift
import SwiftUI

@Observable
final class ProfileViewModel {
    var profile = UserProfile()
    var isLoading = false
    var errorMessage: String? = nil

    @MainActor
    func loadOtherUserProfile(userID: String) async {
        isLoading = true
        defer { isLoading = false }

        // TODO: replace with real API; this is just sample data
        await Task.sleep(NSEC_PER_MSEC * 300)

        profile = UserProfile(
            fullName: "Herman West",
            age: 20,
            headline: "iOS Developer • UI Enthusiast",
            bio: "I love building delightful mobile experiences and sharing knowledge. Coffee-powered and design-first.",
            imageURL: URL(string: "https://images.unsplash.com/photo-1503342217505-b0a15cf70489?w=1200"),
            isVerified: true,
            city: "Seattle",
            country: "USA",
            heightCM: 172,
            weightKG: 75,
            relationshipStatus: "Single",
            ethnicity: "Asian",
            friends: [
                .init(name: "Mary",  avatarURL: URL(string: "https://i.pravatar.cc/100?img=1")),
                .init(name: "Ethan", avatarURL: URL(string: "https://i.pravatar.cc/100?img=2")),
                .init(name: "Ava",   avatarURL: URL(string: "https://i.pravatar.cc/100?img=3")),
                .init(name: "Noah",  avatarURL: URL(string: "https://i.pravatar.cc/100?img=4")),
                .init(name: "Lily",  avatarURL: URL(string: "https://i.pravatar.cc/100?img=5"))
            ],
            interests: ["Guitar", "Music", "Fishing", "Swimming", "Book", "Dancing"],
            lookingFor: ["Friend", "Soul Mate", "Mentor"]
        )
    }

    // For editing own profile later
    @MainActor func saveProfile() async { /* hook API here */ }
}