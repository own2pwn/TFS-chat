//
//  UIImage+Init.swift
//  TFS-chat
//
//  Created by Evgeniy on 22/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import UIKit

public extension UIImage {
    convenience init?(data: Data?) {
        guard let value = data else { return nil }

        self.init(data: value)
    }
}
