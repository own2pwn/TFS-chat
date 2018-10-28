//
//  ChatEntry.swift
//  TFS-chat
//
//  Created by Evgeniy on 28/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import Foundation

struct ChatEntry: Hashable {
    let message: String
    let sender: String
    let receiver: String
    let receivedAt: Date

    init(with message: String, sender: String, receiver: String) {
        self.message = message
        self.sender = sender
        self.receiver = receiver
        receivedAt = Date()
    }
}
