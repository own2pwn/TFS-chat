//
//  DialogCell.swift
//  TFS-chat
//
//  Created by Evgeniy on 07/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import UIKit

protocol MessageCellConfiguration: class {
    var messageText: String? { get set }
}

final class MessageCell: UITableViewCell, MessageCellConfiguration {
    // MARK: - Outlets

    @IBOutlet
    private var messageLabel: UILabel!

    // MARK: - Members

    var messageText: String? {
        get {
            return messageLabel.text
        } set {
            messageLabel.text = newValue
        }
    }

    // MARK: - Interface

    func setup(with text: String) {
        messageLabel.text = text
    }
}
