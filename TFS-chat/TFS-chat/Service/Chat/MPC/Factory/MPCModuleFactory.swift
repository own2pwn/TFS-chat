//
//  MPCModuleFactory.swift
//  TFS-chat
//
//  Created by Evgeniy on 28/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import Foundation

final class MPCModuleFactory {
    // MARK: - Interface

    func makeModule() -> (MultipeerCommunicator, CommunicationManager) {
        let communicator = MultipeerCommunicatorImp()
        let manager = CommunicationManager()
        communicator.delegate = manager

        return (communicator, manager)
    }
}
