import Foundation

public struct AppNotification: Identifiable, Equatable {
    public enum Kind { case message, match, system }
    public let id: UUID
    public var kind: Kind
    public var title: String
    public var message: String
    public var time: String
    public var unread: Bool

    public init(
        id: UUID = UUID(),
        kind: Kind,
        title: String,
        message: String,
        time: String,
        unread: Bool
    ) {
        self.id = id
        self.kind = kind
        self.title = title
        self.message = message
        self.time = time
        self.unread = unread
    }
}