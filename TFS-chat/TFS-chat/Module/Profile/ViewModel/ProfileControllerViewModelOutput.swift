//
//  ProfileControllerViewModelOutput.swift
//  TFS-chat
//
//  Created by Evgeniy on 22/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import Foundation

protocol ProfileControllerViewModelOutput: class {
    var saveButtonEnabled: ((Bool) -> Void)? { get set }

    var viewModelUpdated: VoidBlock? { get set }

    var needsViewUpdate: ((ProfileViewModel) -> Void)? { get set }

    var showAlert: ((UIAlertController) -> Void)? { get set }
}
