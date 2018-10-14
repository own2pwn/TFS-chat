//
//  ThemesViewController-swift.swift
//  TFS-chat
//
//  Created by Evgeniy on 14.10.18.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import UIKit

protocol ThemesModule: class {
    var onColorChanged: ((UIColor) -> Void)? { get set }

    var model: Themes! { get set }
}

final class ThemesViewController: UIViewController, ThemesModule {
    // MARK: - Outlets

    @IBOutlet
    private var themeButtons: [UIButton]!

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Members

    var onColorChanged: ((UIColor) -> Void)?

    var model: Themes!

    // MARK: - Actions

    @IBAction
    private func dismiss() {
        dismiss(animated: true)
    }

    @IBAction
    private func changeTheme(_ sender: UIButton) {
        guard
            let model = model,
            let index = themeButtons.index(of: sender) else { return }

        let backgroundColor: UIColor

        switch index {
        case 0:
            backgroundColor = model.theme1
        case 1:
            backgroundColor = model.theme2
        case 2:
            backgroundColor = model.theme3
        default:
            fatalError()
        }

        view.backgroundColor = backgroundColor
        onColorChanged?(backgroundColor)
    }

    deinit {
        themeButtons = nil
    }
}
