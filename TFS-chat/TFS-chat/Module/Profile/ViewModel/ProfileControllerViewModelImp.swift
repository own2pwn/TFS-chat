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

    func endEditing() {
        currentModel = nil
        saveButtonEnabled?(false)
    }

    func saveDataGCD() {
        saveData(sender: .gcd)
    }

    func saveDataOperation() {
        saveData(sender: .operation)
    }

    // MARK: - Helpers

    private func saveData(sender: SaveButtonType) {
        let worker = getAsyncWorker(for: sender)
    }

    private func getAsyncWorker(for button: SaveButtonType) -> AsyncWorker {
        switch button {
        case .gcd:
            return GCDWorker()
        default:
            fatalError()
        }
    }

    private func updateOutput() {
        let nameValue = textOrNilIfEmpty(name)
        let aboutYouValue = textOrNilIfEmpty(aboutYou)

        guard let name = nameValue else {
            currentModel = nil
            saveButtonEnabled?(false)
            return
        }
        currentModel = UserInfoModel(name: name, about: aboutYouValue, imageData: jpegData(from: image))
        if let currentModel = currentModel,
            initialModel != currentModel {
            saveButtonEnabled?(true)
        }
    }

    private func jpegData(from image: UIImage?) -> Data? {
        guard let image = image else { return nil }

        return image.jpegData(compressionQuality: 0.9)
    }

    private func textOrNilIfEmpty(_ text: String?) -> String? {
        if let textValue = text, textValue.isEmpty {
            return nil
        } else {
            return text
        }
    }
}
