//
//  DialogCell.swift
//  TFS-chat
//
//  Created by Evgeniy on 07/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import UIKit

final class DialogCell: UITableViewCell {
    // MARK: - Outlets

    @IBOutlet
    private var messageLabel: UILabel!

    // MARK: - Interface

    func setup(with text: String) {
        messageLabel.text = text
    }
}
