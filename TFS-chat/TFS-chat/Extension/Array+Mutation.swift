//
//  Array+Mutation.swift
//  TFS-chat
//
//  Created by Evgeniy on 28/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import Foundation

extension Array where Element: Comparable {
    mutating func mutate(element: Element, _ mutation: ((inout Element) -> Void)) {
        guard let index = firstIndex(where: { $0 == element }) else { return }
        var element = self[index]
        mutation(&element)

        self[index] = element
    }
}
