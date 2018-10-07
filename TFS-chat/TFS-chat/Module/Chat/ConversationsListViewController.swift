//
//  ConversationsListViewController.swift
//  TFS-chat
//
//  Created by Evgeniy on 07/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import UIKit

final class ConversationsListViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet
    private var tableView: UITableView!

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButton()

        tableView.estimatedRowHeight = 75
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func addBarButton() {
        let image = UIImage(named: "imgBarButtonProfile")
        let button = UIButton(type: .custom)

        button.setImage(image, for: .normal)
        button.frame.size = CGSize(width: 32, height: 32)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(showProfile), for: .touchUpInside)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
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

    // MARK: - Actions

    @objc
    private func showProfile() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profile = storyboard.instantiateViewController(withIdentifier: "Profile-vc")
        present(profile, animated: true)
    }
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
