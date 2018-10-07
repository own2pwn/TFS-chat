//
//  ConversationCell.swift
//  TFS-chat
//
//  Created by Evgeniy on 07/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import UIKit

final class ConversationCell: UITableViewCell {
    // MARK: - Outlets

    @IBOutlet
    private var recipentLabel: UILabel!

    @IBOutlet
    private var messageLabel: UILabel!

    @IBOutlet
    private var dateLabel: UILabel!

    // MARK: - Interface

    func setup(with model: ConversationCellViewModel) {
        recipentLabel.text = model.name
        messageLabel.text = model.message
        messageLabel.font = model.messageFont
        dateLabel.text = model.dateText

        backgroundColor = model.isOnline ? #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 0.7033725792) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
}
