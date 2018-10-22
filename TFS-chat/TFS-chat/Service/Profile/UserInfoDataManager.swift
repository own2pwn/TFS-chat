//
//  UserInfoDataManager.swift
//  TFS-chat
//
//  Created by Evgeniy on 22/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import Foundation

typealias LoadSavedProfileDataBlock = (() throws -> UserInfoModel?)

struct ImageConvertationError: Error {
    let reason: String = "can't extract jpeg data"
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
        let imageUpdateBlock = getImageUpdateBlock(model.avatar)

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
            let avatar = UIImage(data: imageData)
            let model = UserInfoModel(name: name, about: about, avatar: avatar)

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

    private func getImageUpdateBlock(_ image: UIImage?) -> WorkerBlock? {
        guard let imagePath = defaults.value(forKey: imageKey) as? URL else {
            if let image = image {
                return saveImageBlock(image)
            }
            return nil
        }
        guard let image = image else {
            return removeImageBlock(imagePath)
        }

        return updateImageBlock(image, imagePath: imagePath)
    }

    private func removeImageBlock(_ imagePath: URL) -> WorkerBlock? {
        let block = {
            try self.finder.delete(filePath: imagePath)
        }

        return block
    }

    private func saveImageBlock(_ image: UIImage) -> WorkerBlock {
        let block = {
            guard let imageData = image.jpegData(compressionQuality: 0.95) else {
                throw ImageConvertationError()
            }
            let imagePath = try self.getImagePath()
            try imageData.write(to: imagePath)
        }

        return block
    }

    private func updateImageBlock(_ image: UIImage, imagePath: URL) -> WorkerBlock {
        let block = {
            guard let imageData = image.jpegData(compressionQuality: 0.95) else {
                throw ImageConvertationError()
            }
            try imageData.write(to: imagePath)
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
