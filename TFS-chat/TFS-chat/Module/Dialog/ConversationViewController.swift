//
//  ConversationViewController.swift
//  TFS-chat
//
//  Created by Evgeniy on 07/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import UIKit

final class ConversationViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet var tableView: UITableView!

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Members

    private lazy var messages: [String] = {
        DialogMessageProvider().get()
    }()
}

extension ConversationViewController: UITableViewDelegate {}

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseId = indexPath.row % 2 == 0 ? "incomingCell" : "outgoingCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! MessageCell
        let model = messages[indexPath.row]

        cell.setup(with: model)

        return cell
    }
}
