import SwiftUI

protocol ChatsDataSource {
    func fetchConversations(query: String?) async throws -> [Conversation]
}

@Observable
final class ChatsListViewModel {
    var search: String = ""
    var conversations: [Conversation] = []
    var isLoading = false
    var errorMessage: String?

    private let dataSource: ChatsDataSource

    init(dataSource: ChatsDataSource = MockChatsDataSource()) {
        self.dataSource = dataSource
    }

    @MainActor
    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let items = try await dataSource.fetchConversations(query: search.isEmpty ? nil : search)
            conversations = items
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

// MARK: - Mock
struct MockChatsDataSource: ChatsDataSource {
    func fetchConversations(query: String?) async throws -> [Conversation] {
        let base: [Conversation] = [
            .init(partnerName: "Ethan Carter", lastMessage: "Let’s finalize the deck by tomorrow.", time: "9:12 AM", unreadCount: 2),
            .init(partnerName: "Ava Johnson", lastMessage: "Thanks for the referral.", time: "Yesterday", unreadCount: 0),
            .init(partnerName: "Liam Nguyen", lastMessage: "Shared the profile PDF.", time: "Mon", unreadCount: 1),
            .init(partnerName: "Priya Mehta", lastMessage: "Call at 6 PM works.", time: "Sun", unreadCount: 0)
        ]
        if let q = query, !q.isEmpty {
            return base.filter { $0.partnerName.localizedCaseInsensitiveContains(q) || $0.lastMessage.localizedCaseInsensitiveContains(q) }
        }
        return base
    }
}