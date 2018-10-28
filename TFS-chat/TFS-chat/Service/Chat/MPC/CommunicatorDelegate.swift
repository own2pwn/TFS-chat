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

final class CommunicationManager: CommunicatorDelegate {
    // MARK: - Output

    var onUserFound: ((String, String?) -> Void)?

    var onUserLost: ((String) -> Void)?

    var onMessageReceived: ((String, String, String) -> Void)?

    // MARK: - CommunicatorDelegate

    func didFoundUser(userID: String, userName: String?) {}

    func didLostUser(userID: String) {}

    func failedToStartBrowsingForUsers(error: Error) {
        assertionFailure(error.localizedDescription)
    }

    func failedToStartAdvertising(error: Error) {
        assertionFailure(error.localizedDescription)
    }

    func didReceiveMessage(text: String, fromUser: String, toUser: String) {}
}
