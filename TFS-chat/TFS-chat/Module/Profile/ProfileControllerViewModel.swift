//
//  ProfileControllerViewModel.swift
//  TFS-chat
//
//  Created by Evgeniy on 21/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import UIKit

protocol ProfileControllerViewModel: class {
    var model: UserInfoViewModel? { get }

    var saveButtonEnabledState: ((Bool) -> Void)? { get set }

    func setName(_ name: String?)
    func setAbout(_ about: String?)
    func setAvatar(_ avatar: UIImage)
}

final class ProfileControllerViewModelImp: ProfileControllerViewModel {
    // MARK: - Members

    var model: UserInfoViewModel? {
        didSet {
            if model == nil {
                saveButtonEnabledState?(false)
            } else if oldValue != model {
                saveButtonEnabledState?(true)
            }
        }
    }

    var saveButtonEnabledState: ((Bool) -> Void)?

    // MARK: - Methods

    func setName(_ name: String?) {
        guard let existing = model else {
            model = UserInfoViewModel(name: name, about: nil, avatar: nil)
            return
        }

        model = UserInfoViewModel(name: name, about: existing.about, avatar: existing.avatar)
        nilModelIfNeeded()
    }

    func setAbout(_ about: String?) {
        guard let existing = model else {
            model = UserInfoViewModel(name: nil, about: about, avatar: nil)
            return
        }

        model = UserInfoViewModel(name: existing.name, about: about, avatar: existing.avatar)
        nilModelIfNeeded()
    }

    func setAvatar(_ avatar: UIImage) {
        guard let existing = model else {
            model = UserInfoViewModel(name: nil, about: nil, avatar: avatar)
            return
        }

        model = UserInfoViewModel(name: existing.name, about: existing.about, avatar: avatar)
        nilModelIfNeeded()
    }

    private func nilModelIfNeeded() {
        if model?.name == nil &&
            model?.avatar == nil &&
            model?.about == nil { model = nil }
    }
}
