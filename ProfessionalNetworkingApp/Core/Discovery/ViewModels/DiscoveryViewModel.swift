// DiscoveryViewModel.swift
//
//  Created by Junaed Chowdhury on 19/8/25.
//

import SwiftUI
import Foundation

final class DiscoveryViewModel: ObservableObject {
    // Configuration
    var isCircular: Bool
    var dailyFreeLimit: Int? // nil => unlimited

    // Tracking
    @Published private(set) var swipesToday: Int = 0
    @Published var reachedDailyLimit: Bool = false

    // Base data to restore on reload
    private let baseCards: [UserCard]
    // Current deck
    @Published var cards: [UserCard]

    init(cards: [UserCard] = MockProfiles.sample, isCircular: Bool = true, dailyFreeLimit: Int? = nil) {
        self.baseCards = cards
        self.cards = cards
        self.isCircular = isCircular
        self.dailyFreeLimit = dailyFreeLimit
    }

    func handle(_ action: SwipeAction) {
        // Check daily limit first
        if let limit = dailyFreeLimit, swipesToday >= limit {
            reachedDailyLimit = true
            return
        }

        // Consume one swipe
        swipesToday += 1
        if let limit = dailyFreeLimit, swipesToday >= limit {
            reachedDailyLimit = true
        }

        guard let first = cards.first else { return }

        if isCircular {
            // Circular deck: move the top card to the end
            cards.removeFirst()
            cards.append(first)
        } else {
            // Linear deck: remove the top card until exhausted
            cards.removeFirst()
        }
    }

    func reload() {
        // Restore original order and reset ephemeral state (but not limit counter)
        cards = baseCards
    }

    func resetDailyLimit() {
        swipesToday = 0
        reachedDailyLimit = false
    }
}
