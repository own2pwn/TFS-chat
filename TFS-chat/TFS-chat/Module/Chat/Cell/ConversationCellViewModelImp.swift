//
//  ConversationCellViewModelImp.swift
//  TFS-chat
//
//  Created by Evgeniy on 07/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import UIKit

final class ConversationCellViewModelImp: ConversationCellViewModel {
    // MARK: - Members

    let name: String

    let message: String

    let date: Date?

    let isOnline: Bool

    let hasUnreadMessage: Bool

    let messageFont: UIFont

    let dateText: String?

    // MARK: - Init

    init(with model: ConversationModel) {
        name = model.recipent

        message = model.lastMessage ?? "No messages yet"
        if model.lastMessage != nil {
            messageFont = model.hasUnreadMessages ?
                UIFont.systemFont(ofSize: 17, weight: .medium) : UIFont.systemFont(ofSize: 17)
        } else {
            messageFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
        }

        date = model.lastMessageDate
        dateText = date?.humanString

        isOnline = model.isRecipentOnline
        hasUnreadMessage = model.hasUnreadMessages
    }
}

private extension Date {
    var humanString: String {
        let fmt = DateFormatter()
        let isToday = Calendar.current.isDateInToday(self)
        fmt.dateFormat = isToday ? "HH:mm" : "dd MMM"

        return fmt.string(from: self)
    }
}
