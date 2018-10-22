//
//  GCDWorker.swift
//  TFS-chat
//
//  Created by Evgeniy on 22/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import Foundation

final class GCDWorker: AsyncWorker {
    // MARK: - Members

    private let queue: DispatchQueue = {
        DispatchQueue(label: "pp.service.background", attributes: .concurrent)
    }()

    // MARK: - Interface

    func perform(_ job: @escaping VoidBlock) {
        queue.async {
            job()
        }
    }

    func perform(_ job: @escaping WorkerBlock, completion: @escaping WorkerCompletion) {
        queue.async {
            do {
                try job()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }

    func load<M>(_ loader: @escaping WorkerLoadBlock<M>, completion: @escaping WorkerLoadCompletion<M>) {
        queue.async {
            do {
                let result = try loader()
                completion(nil, result)
            } catch {
                completion(error, nil)
            }
        }
    }
}
