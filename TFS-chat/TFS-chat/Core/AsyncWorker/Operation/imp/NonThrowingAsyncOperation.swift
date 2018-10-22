//
//  NonThrowingAsyncOperation.swift
//  TFS-chat
//
//  Created by Evgeniy on 22/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import Foundation

final class NonThrowingAsyncOperation: AsyncOperation {
    // MARK: - Members

    private let workItem: VoidBlock

    // MARK: - Init

    init(job: @escaping VoidBlock) {
        workItem = job
    }

    // MARK: - Overrides

    override func start() {
        guard !isCancelled else {
            state = .finished
            return
        }
        state = .executing
        workItem()
        state = .finished
    }
}
