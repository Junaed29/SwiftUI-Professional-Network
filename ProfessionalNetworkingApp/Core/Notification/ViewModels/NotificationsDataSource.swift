import SwiftUI

protocol NotificationsDataSource {
    func fetchAll() async throws -> [AppNotification]
}

@Observable
final class NotificationsViewModel {
    enum Filter: CaseIterable { case all, messages, matches, system }

    var items: [AppNotification] = []
    var filter: Filter = .all
    var isLoading = false
    var errorMessage: String?

    private let dataSource: NotificationsDataSource

    init(dataSource: NotificationsDataSource = MockNotificationsDataSource()) {
        self.dataSource = dataSource
    }

    var filtered: [AppNotification] {
        switch filter {
        case .all: return items
        case .messages: return items.filter { $0.kind == .message }
        case .matches: return items.filter { $0.kind == .match }
        case .system: return items.filter { $0.kind == .system }
        }
    }

    @MainActor
    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            items = try await dataSource.fetchAll()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

// MARK: - Mock
struct MockNotificationsDataSource: NotificationsDataSource {
    func fetchAll() async throws -> [AppNotification] {
        [
            .init(kind: .message, title: "New message",
                  message: "Ethan: Can we meet tomorrow at 11 AM?",
                  time: "2m ago", unread: true),
            .init(kind: .match, title: "New match",
                  message: "You matched with Ava Johnson. Say hello and share your profile.",
                  time: "1h ago", unread: true),
            .init(kind: .system, title: "Profile verified",
                  message: "Your identity was verified. You now have a verified badge.",
                  time: "Yesterday", unread: false)
        ]
    }
}