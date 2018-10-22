//
//  AsyncWorker.swift
//  TFS-chat
//
//  Created by Evgeniy on 22/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import Foundation

typealias VoidBlock = () -> Void

typealias WorkerBlock = () throws -> Bool

typealias WorkerCompletion = (Bool, Error?) -> Void

protocol AsyncWorker: class {
    func perform(_ job: @escaping VoidBlock)
    func perform(_ job: @escaping WorkerBlock, completion: @escaping WorkerCompletion)
}
