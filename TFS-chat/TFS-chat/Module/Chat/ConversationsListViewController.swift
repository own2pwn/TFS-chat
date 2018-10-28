//
//  ConversationsListViewController.swift
//  TFS-chat
//
//  Created by Evgeniy on 07/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import UIKit

private let showDialogSegue = "idShowDialog"

final class ConversationsListViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet
    private var tableView: UITableView!

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        setupModule()
        addBarButton()

        tableView.estimatedRowHeight = 74
        tableView.rowHeight = UITableView.automaticDimension
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let selectedItem = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedItem, animated: false)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == showDialogSegue,
            let dialog = segue.destination as? ConversationViewController,
            let model = sender as? ConversationCellViewModel else {
            super.prepare(for: segue, sender: sender)
            return
        }

        dialog.title = model.name
    }

    // MARK: - Members

    private lazy var themeManager = AppThemeManager()

    private let moduleFactory = MPCModuleFactory()

    private let communicator: MultipeerCommunicator = {
        return MultipeerCommunicatorImp()
    }()

    private lazy var communicationManager: CommunicationManager = {
        let manager = CommunicationManager()
        communicator.delegate = manager
        communicator.isOnline = true

        return manager
    }()

    // MARK: - Methods

    private func setupModule() {
        communicationManager.onUserFound = { [weak self] id, username in
            _ = id

            let model = ConversationModel(recipent: username!, lastMessage: nil, lastMessageDate: nil, isRecipentOnline: true, hasUnreadMessages: false)

            let viewModel = ConversationCellViewModelImp(with: model)
            self?.activeConversations.append(viewModel)
            DispatchQueue.main.async { self?.tableView.reloadData() }
        }

        //communicationManager.onUserLost
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

//    private lazy var activeConversations: [ConversationCellViewModel] = {
//        let provider = ConversationListProvider()
//        let models = provider.getOnline()
//
//        ConversationCellViewModelImp(with: ConversationModel)
//
//        return models.map { ConversationCellViewModelImp(with: $0) }
//    }()

    private lazy var activeConversations = [ConversationCellViewModel]()

    private lazy var historyConversations = [ConversationCellViewModel]()

//    private lazy var historyConversations: [ConversationCellViewModel] = {
//        let provider = ConversationListProvider()
//        let models = provider.gethistory()
//
//        return models.map { ConversationCellViewModelImp(with: $0) }
//    }()

    // MARK: - Actions

    @objc
    private func showProfile() {
        let profile = instantiateController(id: "Profile-vc")
        present(profile, animated: true)
    }

    @IBAction
    private func showThemes(_ sender: UIBarButtonItem) {
        // let (nav, themes): (UINavigationController, ThemesViewController) = instantiateNavigationRootController(id: "Themes-vc")
        let (nav, themes): (UINavigationController, ThemesViewController) = instantiateNavigationRootController(id: "Themes-vc-swift")
        let provider = ThemeProvider()

        //themes.delegate = self
        themes.model = provider.get()

        let module: ThemesModule = themes
        module.onColorChanged = { [weak self] newColor in
            self?.updateAppereance(with: newColor)
            self?.logThemeChanging(selectedTheme: newColor)
        }

        present(nav, animated: true)
    }

    // MARK: - Helpers

    private func instantiateNavigationRootController<T: UIViewController>(id: String) -> (UINavigationController, T) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let nav = storyboard.instantiateViewController(withIdentifier: id) as? UINavigationController else { fatalError() }

        return (nav, nav.viewControllers.first as! T)
    }

    private func instantiateController<T: UIViewController>(id: String) -> T {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        return storyboard.instantiateViewController(withIdentifier: id) as! T
    }
}

extension ConversationsListViewController: ​ThemesViewControllerDelegate {
    func themesViewController(_ controller: ThemesViewController, didSelectTheme selectedTheme: UIColor) {
        updateAppereance(with: selectedTheme)
        logThemeChanging(selectedTheme: selectedTheme)
    }

    private func updateAppereance(with color: UIColor) {
        themeManager.setTheme(color)
    }

    private func logThemeChanging(selectedTheme: UIColor) {
        print("did change theme color to \(selectedTheme)")
    }
}

extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model: ConversationCellViewModel
        if indexPath.section == 0 {
            model = activeConversations[indexPath.row]
        } else {
            model = historyConversations[indexPath.row]
        }
        performSegue(withIdentifier: showDialogSegue, sender: model)
    }
}

extension ConversationsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1//sections.count
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
