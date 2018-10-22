//
//  ProfileControllerViewModelImp.swift
//  TFS-chat
//
//  Created by Evgeniy on 22/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import UIKit

private enum SaveButtonType {
    case gcd
    case operation
}

final class ProfileControllerViewModelImp: ProfileControllerViewModel {
    // MARK: - Output

    var saveButtonEnabled: ((Bool) -> Void)?

    var viewModelUpdated: VoidBlock?

    var needsViewUpdate: ((ProfileViewModel) -> Void)?

    var showAlert: ((UIAlertController) -> Void)?

    // MARK: - Members

    var name: String? {
        didSet { updateOutput() }
    }

    var aboutYou: String? {
        didSet { updateOutput() }
    }

    var image: UIImage? {
        didSet { updateOutput() }
    }

    // MARK: - Private

    private var initialModel: UserInfoModel?

    private var currentModel: UserInfoModel?

    // MARK: - Methods

    func loadSavedData() {
        let worker = getAsyncWorker(for: .gcd)
        let service = UserInfoDataManager(worker: worker)

        service.loadSaved { err, model in
            DispatchQueue.main.async {
                if let err = err {
                    let retryBlock: VoidBlock = { [weak self] in
                        self?.loadSavedData()
                    }
                    self.showErrorAlert(with: err, retryBlock: retryBlock)
                } else if let model = model {
                    self.handleLoadedModel(model)
                }
            }
        }
    }

    func endEditing() {}

    func saveDataGCD() {
        saveData(sender: .gcd)
    }

    func saveDataOperation() {
        saveData(sender: .operation)
    }

    // MARK: - Load

    private func handleLoadedModel(_ model: UserInfoModel) {
        name = model.name
        aboutYou = model.about
        image = model.avatar ?? UIImage(named: "imgProfilePlaceholder")

        if let avatar = image {
            let profileViewModel = ProfileViewModel(name: model.name, about: model.about, avatar: avatar)
            needsViewUpdate?(profileViewModel)
        } else { fatalError() }

        initialModel = model
        currentModel = model
        updateOutput()
    }

    // MARK: - Save

    private func saveData(sender: SaveButtonType) {
        guard let model = currentModel else { fatalError() }

        let worker = getAsyncWorker(for: sender)
        let service = UserInfoDataManager(worker: worker)
        service.update(model) { err in
            DispatchQueue.main.async { self.handleDataSave(sender: sender, err) }
        }
    }

    private func handleDataSave(sender: SaveButtonType, _ err: Error?) {
        if let err = err {
            let retryBlock: VoidBlock = { [weak self] in
                self?.saveData(sender: sender)
            }
            showErrorAlert(with: err, retryBlock: retryBlock)
        } else {
            updateView()
        }
    }

    // MARK: - Save Completion

    private func updateView() {
        guard
            let name = name,
            let avatar = image ?? UIImage(named: "imgProfilePlaceholder") else { fatalError() }

        let profileViewModel = ProfileViewModel(name: name, about: aboutYou, avatar: avatar)
        needsViewUpdate?(profileViewModel)
        showSuccessAlert()
    }

    private func showSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "Profile updated!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)

        showAlert?(alert)
    }

    private func showLoadingErrorAlert(with error: Error, retryBlock: @escaping VoidBlock) {
        let alert = makeRetryableAlert(with: "Failed",
                                       message: "Couldn't load saved data!",
                                       retryBlock: retryBlock)

        showAlert?(alert)
    }

    private func showErrorAlert(with error: Error, retryBlock: @escaping VoidBlock) {
        let alert = makeRetryableAlert(with: "Failed",
                                       message: "Profile data not saved!",
                                       retryBlock: retryBlock)

        showAlert?(alert)
    }

    // MARK: - Output

    private func updateOutput() {
        let nameValue = textOrNilIfEmpty(name)
        let aboutYouValue = textOrNilIfEmpty(aboutYou)

        guard let name = nameValue else {
            currentModel = nil
            saveButtonEnabled?(false)
            return
        }
        currentModel = UserInfoModel(name: name, about: aboutYouValue, avatar: image)

        let enableSave = (currentModel != nil && initialModel != currentModel)
        saveButtonEnabled?(enableSave)
    }

    // MARK: - Helpers

    private func makeRetryableAlert(with title: String?, message: String?, retryBlock: @escaping VoidBlock) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        let retry = UIAlertAction(title: "Retry?", style: .default) { _ in
            retryBlock()
        }
        alert.addAction(ok)
        alert.addAction(retry)

        return alert
    }

    private func getAsyncWorker(for button: SaveButtonType) -> AsyncWorker {
        switch button {
        case .gcd:
            return GCDWorker()
        default:
            fatalError()
        }
    }

    private func textOrNilIfEmpty(_ text: String?) -> String? {
        if let textValue = text, textValue.isEmpty {
            return nil
        } else {
            return text
        }
    }
}
