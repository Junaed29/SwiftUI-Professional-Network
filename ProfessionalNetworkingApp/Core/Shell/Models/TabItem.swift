//
//  TabItem.swift
//  ProfessionalNetworkingApp
//
//  Created by Junaed Chowdhury on 19/8/25.
//


import SwiftUI

enum TabItem: Hashable {
    case home, messages, notifications, profile

    var title: String {
        switch self {
        case .home: return "Home"
        case .messages: return "Messages"
        case .notifications: return "Notifications"
        case .profile: return "Profiles"
        }
    }

    // Use SF Symbols now; swap for custom icons later
    var systemImage: String {
        switch self {
        case .home: return "house.fill"
        case .messages: return "bubble.left.and.bubble.right.fill"
        case .notifications: return "bell.fill"
        case .profile: return "person.crop.circle.fill"
        }
    }
}