//
//  ViewController.swift
//  TFS-chat
//
//  Created by Evgeniy on 23/09/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    // MARK: - Outlets

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        log.debug()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        log.debug()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        log.debug()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        log.debug()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        log.debug()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Layout

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        log.debug()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        log.debug()
    }
}
