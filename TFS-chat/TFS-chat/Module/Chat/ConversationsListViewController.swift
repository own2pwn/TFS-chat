//
//  ConversationsListViewController.swift
//  TFS-chat
//
//  Created by Evgeniy on 07/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import UIKit

final class ConversationListProvider {
    // MARK: - Interface

    func getOnline() -> [ConversationModel] {
        let first = ConversationModel(recipent: "Evgeniy Petrov", lastMessage: "Hey man",
                                      lastMessageDate: Date(), isRecipentOnline: true,
                                      hasUnreadMessages: true)

        let second = ConversationModel(recipent: "User 2", lastMessage: "message 2 that a bit longer than the message in the row above",
                                       lastMessageDate: Date().addingTimeInterval(-60 * 10),
                                       isRecipentOnline: true, hasUnreadMessages: true)

        let third = ConversationModel(recipent: "User 3", lastMessage: "message 3",
                                      lastMessageDate: Date().addingTimeInterval(-60 * 15),
                                      isRecipentOnline: true, hasUnreadMessages: false)

        let fourth = ConversationModel(recipent: "User 4", lastMessage: "a message",
                                       lastMessageDate: Date().addingTimeInterval(-60 * 60 * 25),
                                       isRecipentOnline: true, hasUnreadMessages: true)

        let fifth = ConversationModel(recipent: "User 5", lastMessage: "a message [2]",
                                      lastMessageDate: Date().addingTimeInterval(-60 * 60 * 49),
                                      isRecipentOnline: true, hasUnreadMessages: false)

        let sixth = ConversationModel(recipent: "User 6", lastMessage: nil,
                                      lastMessageDate: nil,
                                      isRecipentOnline: true, hasUnreadMessages: false)

        var result = [first, second, third, fourth, fifth, sixth]

        for idx in 7 ... 10 {
            let model = ConversationModel(recipent: "User \(idx)", lastMessage: "a \(idx)th message",
                                          lastMessageDate: Date().addingTimeInterval(-60 * 60 * Double(24 * (idx - 4))),
                                          isRecipentOnline: true, hasUnreadMessages: false)

            result.append(model)
        }

        return result
    }

    func gethistory() -> [ConversationModel] {
        let first = ConversationModel(recipent: "Bot 1", lastMessage: "i'm a bot",
                                      lastMessageDate: Date().addingTimeInterval(-60 * 60 * 25),
                                      isRecipentOnline: false, hasUnreadMessages: true)

        let second = ConversationModel(recipent: "Bot 2", lastMessage: "i'm a bot [2]",
                                       lastMessageDate: Date().addingTimeInterval(-25),
                                       isRecipentOnline: false, hasUnreadMessages: false)

        let third = ConversationModel(recipent: "Bot 3", lastMessage: nil,
                                      lastMessageDate: nil, isRecipentOnline: false,
                                      hasUnreadMessages: false)

        var result = [first, second, third]

        for idx in 4 ... 10 {
            let model = ConversationModel(recipent: "Bot \(idx)", lastMessage: "i'm a bot [\(idx)]",
                                          lastMessageDate: Date().addingTimeInterval(-25 - Double(100 * idx)),
                                          isRecipentOnline: false, hasUnreadMessages: idx % 2 == 0)

            result.append(model)
        }

        return result
    }
}

final class ConversationsListViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet
    private var tableView: UITableView!

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 75
        tableView.rowHeight = UITableView.automaticDimension
    }

    // MARK: - Members

    private let sections = ["Online", "History"]

    private lazy var activeConversations: [ConversationCellViewModel] = {
        let provider = ConversationListProvider()
        let models = provider.getOnline()

        return models.map { ConversationCellViewModelImp(with: $0) }
    }()

    private lazy var historyConversations: [ConversationCellViewModel] = {
        let provider = ConversationListProvider()
        let models = provider.gethistory()

        return models.map { ConversationCellViewModelImp(with: $0) }
    }()

    // MARK: - Methods
}

extension ConversationsListViewController: UITableViewDelegate {}

extension ConversationsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return activeConversations.count
        }

        return historyConversations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ConversationCell
        let model = viewModel(for: indexPath)
        cell.setup(with: model)

        return cell
    }

    private func viewModel(for indexPath: IndexPath) -> ConversationCellViewModel {
        if indexPath.section == 0 {
            return activeConversations[indexPath.row]
        }
        return historyConversations[indexPath.row]
    }
}
