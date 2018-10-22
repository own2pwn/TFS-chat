//
//  UserInfoDataManager.swift
//  TFS-chat
//
//  Created by Evgeniy on 22/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import Foundation

final class Finder {
    // MARK: - Members

    private let fm = FileManager.default

    // MARK: - Interface

    func documentsDir() throws -> URL {
        do {
            return try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        } catch {
            throw error
        }
    }

    func delete(filePath: URL) throws {
        return try fm.removeItem(at: filePath)
    }
}

final class UserInfoDataManager {
    // MARK: - Members

    private let worker: AsyncWorker

    private let defaults = UserDefaults.standard

    private let finder: Finder = {
        Finder()
    }()

    // MARK: - Interface

    func update(_ newInfo: UserInfoModel) {
        let nameUpdateBlock = getStringUpdateBlock(key: nameKey, newValue: newInfo.name)
        let aboutYouUpdateBlock = getStringUpdateBlock(key: aboutYouKey, newValue: newInfo.about)
    }

    // MARK: - Init

    init(worker: AsyncWorker) {
        self.worker = worker
    }

    // MARK: - Helpers

    private func getImageUpdateBlock(image: Data?) {
        // if no data => remove file

        guard let imageURL = defaults.value(forKey: imageKey) as? URL else {
            do {
                let fm = FileManager.default
                let docsFolder = try fm.url(for: .documentDirectory, in: .userDomainMask,
                                            appropriateFor: nil, create: false)

                let imagePath = docsFolder.appendingPathComponent("avatar.jpg")

            } catch {}
        }
    }

    private func removeAvatarBlock() -> WorkerBlock {
        guard let imageURL = defaults.value(forKey: imageKey) as? URL else {
            let block = { true }
            return block
        }

        let block

        finder.delete(filePath: imageURL)
    }

    private func getStringUpdateBlock(key: String, newValue: String?) -> VoidBlock? {
        guard let current = defaults.value(forKey: key) as? String else {
            let block = {
                self.defaults.set(newValue, forKey: key)
            }

            return block
        }
        guard current != newValue else {
            return nil
        }

        let block = {
            self.defaults.set(newValue, forKey: key)
        }

        return block
    }

    private func buildJobBlock() -> WorkerBlock {
        return { false }
    }

    // MARK: - Const

    private let nameKey = "kProfileName"

    private let aboutYouKey = "kProfileAboutYou"

    private let imageKey = "kProfileAvatar"
}
