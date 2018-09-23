//
//  UIApplicationState+fmt.swift
//  TFS-chat
//
//  Created by Evgeniy on 23/09/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import UIKit

public typealias UIApplicationState = UIApplication.State

public extension UIApplication.State {
    public static var current: UIApplication.State {
        return UIApplication.shared.applicationState
    }
}

public extension UIApplication.State {
    public var stringValue: String {
        switch self {
        case .active:
            return "active"
        case .background:
            return "background"
        case .inactive:
            return "inactive"
        }
    }
}
