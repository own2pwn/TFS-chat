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

    func didSendMessage(text: String, fromUser: String, toUser: String)
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
}

final class CommunicationManager: CommunicatorDelegate {
    // MARK: - Output

    var activeChatListUpdated: (([ChatModel]) -> Void)?

    var offlineChatListUpdated: (([ChatModel]) -> Void)?

    // MARK: - Members

    private var chats: [ChatModel] = []

    private var activeChats: [ChatModel] {
        return chats.filter { $0.receiver.isOnline }
    }

    private var offlineChats: [ChatModel] {
        return chats.filter { !$0.receiver.isOnline }
    }

    // MARK: - CommunicatorDelegate

    func didFoundUser(userID: String, userName: String?) {
        let chat = getChatOrCreate(with: userID, userName: userName)
        setUserOnline(true, in: chat)
        activeChatListUpdated?(activeChats)
        offlineChatListUpdated?(offlineChats)

        print("^ found \(userID)")
    }

    func didLostUser(userID: String) {
        guard let chat = getChat(with: userID) else { return }
        setUserOnline(false, in: chat)

        activeChatListUpdated?(activeChats)
        offlineChatListUpdated?(offlineChats)
        print("^ lost \(userID)")
    }

    func failedToStartBrowsingForUsers(error: Error) {
        assertionFailure(error.localizedDescription)
    }

    func failedToStartAdvertising(error: Error) {
        assertionFailure(error.localizedDescription)
    }

    func didSendMessage(text: String, fromUser: String, toUser: String) {
        guard let chat = getChat(with: toUser) else { return }

        let newEntry = ChatEntry(with: text, sender: fromUser, receiver: toUser)
        appendEntry(newEntry, to: chat)
    }

    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        guard let chat = getChat(with: fromUser) else { return }

        let newEntry = ChatEntry(with: text, sender: fromUser, receiver: toUser)
        appendEntry(newEntry, to: chat)
    }

    // MARK: - Helpers

    private func appendEntry(_ entry: ChatEntry, to aChat: ChatModel) {
        chats.mutate(element: aChat) {
            $0.entries.append(entry)
        }
        activeChatListUpdated?(activeChats)
    }

    private func setUserOnline(_ online: Bool, in chat: ChatModel) {
        chats.mutate(element: chat) {
            $0.receiver.isOnline = online
        }
    }

    private func getChatOrCreate(with userID: String, userName: String?) -> ChatModel {
        if let existing = getChat(with: userID) {
            return existing
        }

        return createChat(with: userID, userName: userName)
    }

    private func createChatIfNotExists(with userID: String, userName: String?) {
        if getChat(with: userID) != nil {
            return
        }

        _ = createChat(with: userID, userName: userName)
    }

    private func getChat(with userID: String) -> ChatModel? {
        return chats.first(where: { $0.receiver.userId == userID })
    }

    private func createChat(with userID: String, userName: String?) -> ChatModel {
        let newChat = ChatModel(userId: userID, userName: userName)
        chats.append(newChat)

        return newChat
    }
}
