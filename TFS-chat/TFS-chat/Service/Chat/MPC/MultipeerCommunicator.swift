//
//  MultipeerCommunicator.swift
//  TFS-chat
//
//  Created by Evgeniy on 27/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol MultipeerCommunicator: class {
    func sendMessage(_ message: String, to userID: String, completion: ((Bool, Error?) -> Void)?)

    var localPeerID: String { get }

    var delegate: CommunicatorDelegate? { get set }

    var isOnline: Bool { get set }
}

struct MultipeerCommunicatorError: Error {
    let reason: String
}
