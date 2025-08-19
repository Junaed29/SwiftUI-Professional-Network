// DiscoveryViewModel.swift

import Foundation

final class DiscoveryViewModel: ObservableObject {
    @Published var cards: [UserCard] = DiscoveryViewModel.sampleCards()

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
        let f1 = URL(string: "https://images.unsplash.com/photo-1552053831-71594a27632d?w=200&q=60")!
        let f2 = URL(string: "https://images.unsplash.com/photo-1544723795-3fb6469f5b39?w=200&q=60")!
        let f3 = URL(string: "https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=200&q=60")!
        let f4 = URL(string: "https://images.unsplash.com/photo-1531123414780-f742e8c2d21a?w=200&q=60")!

        return [
            UserCard(
                name: "Herman West",
                age: 20,
                location: "Seattle, USA",
                tag: "Versatile",
                imageURL: URL(string: "https://images.unsplash.com/photo-1503342217505-b0a15cf70489?w=1200&q=80"),
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
                imageURL: URL(string: "https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?w=1200&q=80"),
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
                imageURL: URL(string: "https://images.unsplash.com/photo-1519340247619-8e3f06eb8f91?w=1200&q=80"),
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
