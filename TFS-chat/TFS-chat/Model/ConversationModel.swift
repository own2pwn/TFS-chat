//
//  ConversationModel.swift
//  TFS-chat
//
//  Created by Evgeniy on 07/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import Foundation

struct ConversationModel {
    let recipent: String
    let lastMessage: String?
    let lastMessageDate: Date?
    let isRecipentOnline: Bool
    let hasUnreadMessages: Bool
}
