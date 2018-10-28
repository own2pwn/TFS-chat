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

    @IBOutlet
    private var tableView: UITableView!

    @IBOutlet
    private var messageTextView: UITextView!

    @IBOutlet
    private var messageTextViewBottom: NSLayoutConstraint!

    // MARK: - Members

    var communicator: MultipeerCommunicator!

    var chat: ChatModel!

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        setupKeyboardHandling()
    }

    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc
    private func onKeyboardWillShow(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        messageTextViewBottom.constant = keyboardFrame.size.height

        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }

    @objc
    private func onKeyboardWillHide() {
        messageTextViewBottom.constant = 0
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - Members

    var messages: [ChatEntry] {
        return chat.entries
    }

    // MARK: - Actions

    @IBAction
    private func sendMessage() {
        guard let message = messageTextView.text else { return }
        communicator.sendMessage(message, to: chat.receiver.userId) { [weak self] success, err in
            DispatchQueue.main.async { self?.handleMessageCallback(message: message, success, err: err) }
        }
    }

    private func handleMessageCallback(message: String, _ success: Bool, err: Error?) {
        if let err = err {
            let alert = UIAlertController(title: "Error while sending message", message: err.localizedDescription, preferredStyle: .alert)

            let close = UIAlertAction(title: "Close", style: .default, handler: nil)
            alert.addAction(close)

            present(alert, animated: true)
        } else {
            let newEntry = ChatEntry(with: message, sender: communicator.localPeerID, receiver: chat.receiver.userId)
            chat.entries.append(newEntry)

            let newPathIndex = tableView.numberOfRows(inSection: 0)
            let newPath = IndexPath(row: newPathIndex, section: 0)
            tableView.insertRows(at: [newPath], with: .automatic)
            messageTextView.text = ""
        }
    }
}

extension ConversationViewController: UITableViewDelegate {}

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = messages[indexPath.row]
        let reuseId = getCellReuseID(for: model)
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! MessageCell

        cell.setup(with: model.message)
        cell.selectionStyle = .none

        return cell
    }

    private func getCellReuseID(for message: ChatEntry) -> String {
        if message.sender == communicator.localPeerID {
            return "outgoingCell"
        }
        return "incomingCell'"
    }
}
