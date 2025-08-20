//
//  ChatThreadDataSource.swift
//  ProfessionalNetworkingApp
//
//  Created by Junaed Chowdhury on 19/8/25.
//


import SwiftUI

protocol ChatThreadDataSource {
    func loadThread(partner: String) async throws -> [ChatMessage]
    func send(_ text: String, to partner: String) async throws -> ChatMessage
}

@Observable
final class ChatThreadViewModel {
    let partner: String
    var messages: [ChatMessage] = []
    var input: String = ""
    var isSending = false
    var isLoading = false
    var errorMessage: String?

    private let dataSource: ChatThreadDataSource

    init(partner: String, dataSource: ChatThreadDataSource = MockChatThreadDataSource()) {
        self.partner = partner
        self.dataSource = dataSource
    }

    @MainActor
    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            messages = try await dataSource.loadThread(partner: partner)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func send() async {
        let text = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        isSending = true
        defer { isSending = false }
        do {
            let msg = try await dataSource.send(text, to: partner)
            messages.append(msg)
            input = ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

// MARK: - Mock
struct MockChatThreadDataSource: ChatThreadDataSource {
    func loadThread(partner: String) async throws -> [ChatMessage] {
        [
            .init(text: "Hi, thanks for connecting!", time: "10:02 AM", isMe: false),
            .init(text: "Likewise. Are you available for a quick call tomorrow?", time: "10:05 AM", isMe: true),
            .init(text: "Yes, after 4 PM works well.", time: "10:06 AM", isMe: false)
        ]
    }

    func send(_ text: String, to partner: String) async throws -> ChatMessage {
        .init(text: text, time: "Now", isMe: true)
    }
}