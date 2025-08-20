//
//  ProfileViewModel.swift
//  ProfessionalNetworkingApp
//
//  Created by Junaed Chowdhury on 19/8/25.
//


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

        do {
            try await Task.sleep(for: .milliseconds(600))
        } catch { }

        var p = MockProfiles.sample.first ?? UserProfile()
        let others = Array(MockProfiles.sample.dropFirst().prefix(3))
        p.connections = others.map { Connection(name: $0.fullName, headline: $0.headline, avatarURL: $0.avatarURL) }
        profile = p
    }

    // For editing own profile later
    @MainActor func saveProfile() async { /* hook API here */ }
}
