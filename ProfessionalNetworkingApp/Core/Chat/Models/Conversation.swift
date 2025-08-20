//
//  Conversation.swift
//  ProfessionalNetworkingApp
//
//  Created by Junaed Chowdhury on 19/8/25.
//


import Foundation

public struct Conversation: Identifiable, Equatable {
    public let id: UUID
    public var partnerName: String
    public var lastMessage: String
    public var time: String
    public var unreadCount: Int

    public init(
        id: UUID = UUID(),
        partnerName: String,
        lastMessage: String,
        time: String,
        unreadCount: Int
    ) {
        self.id = id
        self.partnerName = partnerName
        self.lastMessage = lastMessage
        self.time = time
        self.unreadCount = unreadCount
    }
}