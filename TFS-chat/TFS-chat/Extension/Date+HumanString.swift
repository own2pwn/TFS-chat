//
//  Date+HumanString.swift
//  TFS-chat
//
//  Created by Evgeniy on 29/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import Foundation

extension Date {
    var humanString: String {
        let fmt = DateFormatter()
        let isToday = Calendar.current.isDateInToday(self)
        fmt.dateFormat = isToday ? "HH:mm" : "dd MMM"

        return fmt.string(from: self)
    }
}
