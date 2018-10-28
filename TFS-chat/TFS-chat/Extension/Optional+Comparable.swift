//
//  Optional+Comparable.swift
//  TFS-chat
//
//  Created by Evgeniy on 28/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import Foundation

extension Optional where Wrapped: Comparable {
    static func < (lhs: Optional, rhs: Optional) -> Bool {
        switch (lhs, rhs) {
        case let (.some(left), .some(right)):
            return left < right
        default:
            return false
        }
    }
}
