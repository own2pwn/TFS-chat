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

    func update(_ newInfo: UserInfoModel, completion: @escaping (Error?) -> Void) {
        let job = buildJobBlock(newInfo)
        worker.perform(job, completion: completion)
    }

    // MARK: - Init

    init(worker: AsyncWorker) {
        self.worker = worker
    }

    // MARK: - Helpers

    private func buildJobBlock(_ model: UserInfoModel) -> WorkerBlock {
        let nameUpdateBlock = getStringUpdateBlock(key: nameKey, newValue: model.name)
        let aboutYouUpdateBlock = getStringUpdateBlock(key: aboutYouKey, newValue: model.about)
        let imageUpdateBlock = getImageUpdateBlock(model.imageData)

        let block: WorkerBlock = { [nameBlock = nameUpdateBlock, aboutBlock = aboutYouUpdateBlock, imageBlock = imageUpdateBlock] in
            if let nameBlock = nameBlock {
                nameBlock()
            }
            if let aboutBlock = aboutBlock {
                aboutBlock()
            }
            if let imageBlock = imageBlock {
                try imageBlock()
            }
        }

        return block
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

    // MARK: - Image

    private func getImageUpdateBlock(_ imageData: Data?) -> WorkerBlock? {
        guard let imagePath = defaults.value(forKey: imageKey) as? URL else {
            if let data = imageData {
                return saveImageBlock(data)
            }
            return nil
        }
        guard let imageData = imageData else {
            return removeImageBlock(imagePath)
        }

        return updateImageBlock(imageData, imagePath: imagePath)
    }

    private func removeImageBlock(_ imagePath: URL) -> WorkerBlock? {
        let block = {
            try self.finder.delete(filePath: imagePath)
        }

        return block
    }

    private func saveImageBlock(_ image: Data) -> WorkerBlock {
        let block = {
            let docsDir = try self.finder.documentsDir()
            let imagePath = docsDir.appendingPathComponent("avatar.jpg")
            try image.write(to: imagePath)
        }

        return block
    }

    private func updateImageBlock(_ image: Data, imagePath: URL) -> WorkerBlock {
        let block = {
            try image.write(to: imagePath)
        }

        return block
    }

    // MARK: - Const

    private let nameKey = "kProfileName"

    private let aboutYouKey = "kProfileAboutYou"

    private let imageKey = "kProfileAvatar"
}
