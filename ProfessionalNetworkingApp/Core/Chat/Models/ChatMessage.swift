//
//  ChatMessage.swift
//  ProfessionalNetworkingApp
//
//  Created by Junaed Chowdhury on 19/8/25.
//


import Foundation

public struct ChatMessage: Identifiable, Equatable {
    public let id: UUID
    public var text: String
    public var time: String
    public var isMe: Bool

    public init(id: UUID = UUID(), text: String, time: String, isMe: Bool) {
        self.id = id
        self.text = text
        self.time = time
        self.isMe = isMe
    }
}