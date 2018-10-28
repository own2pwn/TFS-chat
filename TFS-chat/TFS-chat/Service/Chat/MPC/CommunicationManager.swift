//
//  CommunicatorDelegate.swift
//  TFS-chat
//
//  Created by Evgeniy on 28/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import Foundation

protocol CommunicatorDelegate: class {
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)

    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)

    func didReceiveMessage(text: String, fromUser: String, toUser: String)
}

struct ChatUser {
    let userId: String
    let userName: String?

    var isOnline: Bool

    mutating func setOnline(_ online: Bool) {
        isOnline = online
    }
}

struct Chat {
    var receiver: ChatUser
    let entries: [ChatEntry]

    init(userId: String, userName: String?, entries: [ChatEntry] = []) {
        let user = ChatUser(userId: userId, userName: userName, isOnline: true)
        receiver = user
        self.entries = entries
    }

    var lastMessageText: String? {
        return entries.last?.message
    }
}

struct ChatEntry {
    let message: String
    let receivedAt: Date

    init(with message: String) {
        self.message = message
        receivedAt = Date()
    }
}

final class Box<Value> {
    var value: Value

    init(value: Value) {
        self.value = value
    }
}

final class CommunicationManager: CommunicatorDelegate {
    // MARK: - Output

    var onUserFound: ((String, String?) -> Void)?

    var onUserLost: ((String) -> Void)?

    var onMessageReceived: ((String, String, String) -> Void)?

    var activeChatListUpdated: (([Chat]) -> Void)?

    // MARK: - Members

    // private var chats: [Chat] = []

//    private var activeChats: [Chat] {
//        return chats.filter { $0.receiver.isOnline }
//    }

    private var chatBox = Box<[Chat]>(value: [])

    private var activeChats: [Chat] {
        let filtered = chatBox.value.filter { $0.receiver.isOnline }

        return filtered
    }

    // MARK: - CommunicatorDelegate

    func didFoundUser(userID: String, userName: String?) {
        createChatIfNotExists(with: userID, userName: userName)
        activeChatListUpdated?(activeChats)

        onUserFound?(userID, userName)
        print("^ found \(userID)")
    }

    func didLostUser(userID: String) {
        guard var chat = getChat(with: userID) else { return }
        chat.receiver.setOnline(false)

        activeChatListUpdated?(activeChats)
        onUserLost?(userID)
        print("^ lost \(userID)")
    }

    func failedToStartBrowsingForUsers(error: Error) {
        assertionFailure(error.localizedDescription)
    }

    func failedToStartAdvertising(error: Error) {
        assertionFailure(error.localizedDescription)
    }

    func didReceiveMessage(text: String, fromUser: String, toUser: String) {}

    // MARK: - Helpers

    private func createChatIfNotExists(with userID: String, userName: String?) {
        if getChat(with: userID) != nil {
            return
        }

        _ = createChat(with: userID, userName: userName)
    }

    private func getChat(with userID: String) -> Chat? {
        return chatBox.value.first(where: { $0.receiver.userId == userID })
    }

    private func createChat(with userID: String, userName: String?) -> Chat {
        let newChat = Chat(userId: userID, userName: userName)
        chatBox.value.append(newChat)

        return newChat
    }
}
