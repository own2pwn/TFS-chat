//
//  ChatUser.swift
//  TFS-chat
//
//  Created by Evgeniy on 28/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import Foundation

struct ChatUser: Hashable {
    let userId: String
    let userName: String?

    var isOnline: Bool
}
