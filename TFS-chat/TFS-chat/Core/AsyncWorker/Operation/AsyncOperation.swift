//
//  AsyncOperation.swift
//  TFS-chat
//
//  Created by Evgeniy on 22/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import Foundation

public enum OperationState: String {
    case ready
    case executing
    case finished

    var keyPath: String {
        return "is" + rawValue.capitalized
    }
}

open class AsyncOperation: Operation {
    open var state = OperationState.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }

        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }

    open override var isAsynchronous: Bool { return true }

    open override var isExecuting: Bool { return state == .executing }

    open override var isFinished: Bool { return state == .finished }
}
