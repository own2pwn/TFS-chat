//
//  UserInfoDataManager.swift
//  TFS-chat
//
//  Created by Evgeniy on 22/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import Foundation

typealias LoadSavedProfileDataBlock = (() throws -> UserInfoModel?)

final class UserInfoDataManager {
    // MARK: - Members

    private let worker: AsyncWorker

    private let defaults = UserDefaults.standard

    private let finder: Finder = {
        Finder()
    }()

    // MARK: - Interface

    func update(_ newInfo: UserInfoModel, completion: @escaping (Error?) -> Void) {
        let job = makeSaveDataBlock(newInfo)
        worker.perform(job, completion: completion)
    }

    func loadSaved(completion: @escaping ((Error?, UserInfoModel?) -> Void)) {
        let loader = makeLoadDataBlock()

        worker.load(loader) { err, model in
            if let model = model {
                completion(err, model)
            } else {
                completion(err, nil)
            }
        }
    }

    // MARK: - Init

    init(worker: AsyncWorker) {
        self.worker = worker
    }

    // MARK: - Save / Load

    private func makeSaveDataBlock(_ model: UserInfoModel) -> WorkerBlock {
        let nameUpdateBlock = getStringUpdateBlock(key: nameKey, newValue: model.name)
        let aboutYouUpdateBlock = getStringUpdateBlock(key: aboutYouKey, newValue: model.about)
        let imageUpdateBlock = getImageUpdateBlock(model.imageData)

        let block: WorkerBlock = { [nameBlock = nameUpdateBlock,
                                    aboutBlock = aboutYouUpdateBlock,
                                    imageBlock = imageUpdateBlock] in
            nameBlock?()
            aboutBlock?()
            try imageBlock?()
        }

        return block
    }

    private func makeLoadDataBlock() -> LoadSavedProfileDataBlock {
        let block: LoadSavedProfileDataBlock = {
            let defaults = self.defaults

            guard let name = defaults.value(forKey: self.nameKey) as? String else {
                return nil
            }
            let about = defaults.value(forKey: self.aboutYouKey) as? String
            let imagePath = try self.getImagePath()
            let imageData = try? Data(contentsOf: imagePath)
            let model = UserInfoModel(name: name, about: about, imageData: imageData)

            return model
        }

        return block
    }

    // MARK: - Helpers

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
            let imagePath = try self.getImagePath()
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

    private func getImagePath() throws -> URL {
        let docsDir = try finder.documentsDir()
        let imagePath = docsDir.appendingPathComponent("avatar.jpg")

        return imagePath
    }

    // MARK: - Const

    private let nameKey = "kProfileName"

    private let aboutYouKey = "kProfileAboutYou"

    private let imageKey = "kProfileAvatar"
}
