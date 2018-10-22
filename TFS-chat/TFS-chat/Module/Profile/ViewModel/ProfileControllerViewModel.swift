//
//  ProfileControllerViewModel.swift
//  TFS-chat
//
//  Created by Evgeniy on 22/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import UIKit

struct ProfileViewModel {
    let name: String
    let about: String?
    let avatar: UIImage
}

protocol ProfileControllerViewModel: ProfileControllerViewModelOutput {
    var name: String? { get set }
    var aboutYou: String? { get set }
    var image: UIImage? { get set }

    func loadSavedData()
    func endEditing()
    func saveDataGCD()
    func saveDataOperation()
}
