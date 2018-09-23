//
//  Logger.swift
//  TFS-chat
//
//  Created by Evgeniy on 23/09/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import Foundation
import UIKit

public let log = Logger(with: .inactive)

public final class Logger {
    // MARK: - Members

    private var previousState: UIApplicationState

    // MARK: - Interface

    public func debug(_ caller: String = #function) {
        #if !LOGS_ENABLED
            return;
        #endif

        let currentState = UIApplicationState.current

        if currentState != previousState {
            print("Application moved from \(previousState.stringValue) to \(currentState.stringValue): [\(caller)]")
            previousState = currentState
        } else {
            print("Application is \(currentState.stringValue): \(caller)")
        }
    }

    // MARK: - Init

    public init(with state: UIApplicationState) {
        previousState = state
    }
}
