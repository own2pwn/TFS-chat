//
//  AppThemeManager.swift
//  TFS-chat
//
//  Created by Evgeniy on 14.10.18.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import Foundation

final class AppThemeManager {
    // MARK: - Members

    private let kThemeColor = "kThemeColor"

    private let defaults = UserDefaults.standard

    private let worker: AsyncWorker = {
        GCDWorker()
    }()

    // MARK: - Interface

    func setTheme(_ color: UIColor) {
        UINavigationBar.appearance().backgroundColor = color
        saveColor(color)
    }

    func restoreTheme() {
        guard
            let colorData = defaults.value(forKey: kThemeColor) as? Data,
            let color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor else { return }

        UINavigationBar.appearance().backgroundColor = color
    }

    // MARK: - Helpers

    private func saveColor(_ color: UIColor) {
        let job = {
            let colorData = NSKeyedArchiver.archivedData(withRootObject: color)
            self.defaults.set(colorData, forKey: self.kThemeColor)
        }

        worker.perform(job)
    }
}
