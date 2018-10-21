//
//  ProfileControllerViewModel.swift
//  TFS-chat
//
//  Created by Evgeniy on 21/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import UIKit

protocol ProfileControllerViewModelOutput: class {
    var saveButtonEnabled: ((Bool) -> Void)? { get set }
}

protocol ProfileControllerViewModel: ProfileControllerViewModelOutput {
    var model: UserInfoViewModel? { get }

    var name: String? { get set }
    var aboutYou: String? { get set }
    var image: UIImage? { get set }

    func endEditing()
}

final class ProfileControllerViewModelImp: ProfileControllerViewModel {
    // MARK: - Output

    var saveButtonEnabled: ((Bool) -> Void)?

    // MARK: - Members

    var model: UserInfoViewModel?

    var name: String? {
        didSet { updateOutput() }
    }

    var aboutYou: String? {
        didSet { updateOutput() }
    }

    var image: UIImage? {
        didSet { updateOutput() }
    }

    // MARK: - Methods

    func endEditing() {
        model = nil
        saveButtonEnabled?(false)
    }

    // MARK: - Helpers

    private func updateOutput() {
        let nameValue = textOrNilIfEmpty(name)
        let aboutYouValue = textOrNilIfEmpty(aboutYou)

        guard let name = nameValue else {
            model = nil
            saveButtonEnabled?(false)
            return
        }
        let oldModel = model
        model = UserInfoViewModel(name: name, about: aboutYouValue, imageData: jpegData(from: image))
        if oldModel != model {
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
