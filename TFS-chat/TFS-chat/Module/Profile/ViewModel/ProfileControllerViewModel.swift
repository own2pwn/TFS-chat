//
//  ProfileControllerViewModel.swift
//  TFS-chat
//
//  Created by Evgeniy on 22/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import UIKit

protocol ProfileControllerViewModel: ProfileControllerViewModelOutput {
    var name: String? { get set }
    var aboutYou: String? { get set }
    var image: UIImage? { get set }

    func endEditing()
}
