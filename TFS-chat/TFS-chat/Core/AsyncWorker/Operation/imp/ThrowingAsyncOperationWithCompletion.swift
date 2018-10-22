//
//  ThrowingAsyncOperationWithCompletion.swift
//  TFS-chat
//
//  Created by Evgeniy on 22/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import Foundation

final class ThrowingAsyncOperationWithCompletion: AsyncOperation {
    // MARK: - Members

    private let workItem: WorkerBlock

    private let completion: WorkerCompletion

    // MARK: - Init

    init(job: @escaping WorkerBlock, completion: @escaping WorkerCompletion) {
        workItem = job
        self.completion = completion
    }

    // MARK: - Overrides

    override func start() {
        guard !isCancelled else {
            state = .finished
            return
        }
        state = .executing
        defer { state = .finished }

        do {
            try workItem()
            completion(nil)
        } catch {
            completion(error)
        }
    }
}
