//
//  ThemeProvider.swift
//  TFS-chat
//
//  Created by Evgeniy on 14.10.18.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import UIKit

final class ThemeProvider {
    // MARK: - Interface

    func get() -> Themes {
        let result = Themes(firstColor: .green,
                            andSecondColor: .blue,
                            andThirdColor: .yellow)

        return result
    }
}
