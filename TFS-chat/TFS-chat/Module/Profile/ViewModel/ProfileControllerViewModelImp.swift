//
//  ProfileControllerViewModelImp.swift
//  TFS-chat
//
//  Created by Evgeniy on 22/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import UIKit

final class ProfileControllerViewModelImp: ProfileControllerViewModel {
    // MARK: - Output

    var saveButtonEnabled: ((Bool) -> Void)?

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

    private var initialModel: UserInfoViewModel?

    private var currentModel: UserInfoViewModel?

    // MARK: - Methods

    func endEditing() {
        currentModel = nil
        saveButtonEnabled?(false)
    }

    // MARK: - Helpers

    private func updateOutput() {
        let nameValue = textOrNilIfEmpty(name)
        let aboutYouValue = textOrNilIfEmpty(aboutYou)

        guard let name = nameValue else {
            currentModel = nil
            saveButtonEnabled?(false)
            return
        }
        currentModel = UserInfoViewModel(name: name, about: aboutYouValue, imageData: jpegData(from: image))
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
