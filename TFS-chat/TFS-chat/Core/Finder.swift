//
//  Finder.swift
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
