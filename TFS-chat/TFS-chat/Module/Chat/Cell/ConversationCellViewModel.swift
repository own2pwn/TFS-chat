//
//  ConversationCellViewModel.swift
//  TFS-chat
//
//  Created by Evgeniy on 07/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import UIKit

protocol ConversationCellViewModel: class {
    var name: String { get }
    var message: String { get }
    var date: Date? { get }
    var isOnline: Bool { get }
    var hasUnreadMessage: Bool { get }

    var messageFont: UIFont { get }
    var dateText: String? { get }
}
