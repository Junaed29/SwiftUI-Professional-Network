// DiscoveryViewModel.swift

import SwiftUI
import Observation

@Observable
final class DiscoveryViewModel: ObservableObject {
    var cards: [UserCard] = DiscoveryViewModel.sampleCards()

    func handle(_ action: SwipeAction) {
        guard !cards.isEmpty else { return }
        // In a real app, record like/pass here.
        cards.removeFirst()
        if cards.count < 3 {
            // Append more to keep the deck going
            cards.append(contentsOf: DiscoveryViewModel.sampleCards().shuffled().prefix(2))
        }
    }

    func reload() {
        cards = Self.sampleCards().shuffled()
    }
}

extension DiscoveryViewModel {
    static func sampleCards() -> [UserCard] {
        let f1 = URL(string: "https://i.pravatar.cc/500?img=1")!
        let f2 = URL(string: "https://i.pravatar.cc/500?img=3")!
        let f3 = URL(string: "https://i.pravatar.cc/500?img=4")!
        let f4 = URL(string: "https://i.pravatar.cc/500?img=5")!

        return [
            UserCard(
                name: "Herman West",
                age: 20,
                location: "Seattle, USA",
                tag: "Versatile",
                imageURL: URL(string: "https://i.pravatar.cc/500?img=10"),
                photos: [],
                bio: "My name is Herman and I enjoy meeting new people and finding ways to help them have an uplifting experience. I enjoy reading, and the knowledge…",
                heightCM: 172,
                weightKG: 75,
                relationshipStatus: "Single",
                ethnicity: "Asian",
                interests: ["Guitar", "Music", "Fishing", "Swimming", "Book", "Dancing"],
                lookingFor: ["Friend", "Soul Mate", "Marriage"],
                friends: [f1, f2, f3, f4]
            ),
            UserCard(
                name: "Julia Park",
                age: 24,
                location: "San Francisco, USA",
                tag: "Designer",
                imageURL: URL(string: "https://i.pravatar.cc/500?img=40"),
                photos: [],
                bio: "Product designer who loves hiking and cooking.",
                heightCM: 165,
                weightKG: 56,
                relationshipStatus: "Single",
                ethnicity: "Korean",
                interests: ["Hiking", "Coffee", "Art", "Photography"],
                lookingFor: ["Friend", "Dating"],
                friends: [f2, f3]
            ),
            UserCard(
                name: "John Carter",
                age: 22,
                location: "Austin, USA",
                tag: "Athletic",
                imageURL: URL(string: "https://i.pravatar.cc/500?img=50"),
                photos: [],
                bio: "Runner and weekend traveler. Building an indie app in Swift.",
                heightCM: 180,
                weightKG: 78,
                relationshipStatus: "Single",
                ethnicity: "Caucasian",
                interests: ["Running", "Travel", "Tech"],
                lookingFor: ["Dating"],
                friends: [f1, f4]
            )
        ]
    }
}
