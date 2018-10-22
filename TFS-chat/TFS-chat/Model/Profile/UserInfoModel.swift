//
//  UserInfoViewModel.swift
//  TFS-chat
//
//  Created by Evgeniy on 21/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import Foundation

struct UserInfoModel: Hashable {
    let name: String
    let about: String?
    let imageData: Data?
}
