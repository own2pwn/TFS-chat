//
//  MultipeerCommunicatorImp.swift
//  TFS-chat
//
//  Created by Evgeniy on 28/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import Foundation
import MultipeerConnectivity

final class MultipeerCommunicatorImp: NSObject, MultipeerCommunicator {
    // MARK: - Interface

    var delegate: CommunicatorDelegate?

    var isOnline: Bool = false {
        didSet { setOnline(isOnline) }
    }

    // MARK: - Members

    private var sessions = Set<MCSession>()

    private let me: MCPeerID

    private let advertiser: MCNearbyServiceAdvertiser

    private let browser: MCNearbyServiceBrowser

    // MARK: - Init

    override init() {
        me = MultipeerCommunicatorImp.loadOrCreatePeer()
        advertiser = MultipeerCommunicatorImp.makeAdvertiser(for: me)
        browser = MultipeerCommunicatorImp.makeBrowser(for: me)
        super.init()

        advertiser.delegate = self
        browser.delegate = self
    }

    // MARK: - Methods

    func sendMessage(_ message: String, to userID: String, completion: ((Bool, Error?) -> Void)?) {
        guard let session = getSession(with: userID) else {
            let err = MultipeerCommunicatorError(reason: "no session found for \(userID)")
            completion?(false, err)
            return
        }
        guard let serialized = makeMessage(with: message) else {
            let err = MultipeerCommunicatorError(reason: "can't serialized message")
            completion?(false, err)
            return
        }

        do {
            try session.send(serialized, toPeers: session.connectedPeers, with: .reliable)
            completion?(true, nil)
        } catch {
            completion?(false, error)
        }
    }

    // MARK: - Helpers

    private func setOnline(_ online: Bool) {
        if online {
            advertiser.startAdvertisingPeer()
            browser.startBrowsingForPeers()
        } else {
            advertiser.stopAdvertisingPeer()
            browser.stopBrowsingForPeers()
        }
    }

    private func makeMessage(with text: String) -> Data? {
        let dict = ["eventType": "TextMessage",
                    "messageId": generateMessageId(),
                    "text": text]

        return try? JSONSerialization.data(withJSONObject: dict, options: [])
    }

    private func createSession() -> MCSession {
        let newSession = MCSession(peer: me, securityIdentity: nil, encryptionPreference: .none)
        newSession.delegate = self

        sessions.insert(newSession)

        return newSession
    }

    private func isSessionExists(with peer: MCPeerID) -> Bool {
        let session = getSession(with: peer)

        return session != nil
    }

    private func generateMessageId() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)!.base64EncodedString()

        return string
    }

    // MARK: - Initialization

    private static func loadOrCreatePeer() -> MCPeerID {
        let defaults = UserDefaults.standard

//        if let peerData = defaults.value(forKey: peerKey) as? Data, let savedPeer = NSKeyedUnarchiver.unarchiveObject(with: peerData) as? MCPeerID {
//            return savedPeer
//        }
        let newPeer = MCPeerID(displayName: UIDevice.current.name)
        let newPeerData = NSKeyedArchiver.archivedData(withRootObject: newPeer)
        defaults.set(newPeerData, forKey: peerKey)

        return newPeer
    }

    private static func makeAdvertiser(for peer: MCPeerID) -> MCNearbyServiceAdvertiser {
        let discovery = ["userName": "Evgeniy"]

        let advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: discovery, serviceType: serviceType)

        return advertiser
    }

    private static func makeBrowser(for peer: MCPeerID) -> MCNearbyServiceBrowser {
        let browser = MCNearbyServiceBrowser(peer: peer, serviceType: serviceType)

        return browser
    }

    // MARK: - Const

    private static let peerKey = "kMCPeer"

    private static let serviceType = "tinkoff-chat"
}

extension MultipeerCommunicatorImp: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {}

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments), let json = jsonObject as? [String: Any], let eventType = json["eventType"] as? String, eventType == "TextMessage", let message = json["text"] as? String else { return }

        print("^ text: \(message)")
        delegate?.didReceiveMessage(text: message, fromUser: peerID.displayName, toUser: me.displayName)
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}

extension MultipeerCommunicatorImp: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        guard !isSessionExists(with: peerID) else {
            invitationHandler(false, nil)
            return
        }
        let newSession = createSession()
        invitationHandler(true, newSession)
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        delegate?.failedToStartAdvertising(error: error)
        isOnline = false
    }
}

extension MultipeerCommunicatorImp: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        connect(with: peerID)

        let userName = getUserName(from: info)
        delegate?.didFoundUser(userID: peerID.displayName, userName: userName)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        removeSession(with: peerID)
        delegate?.didLostUser(userID: peerID.displayName)
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        delegate?.failedToStartBrowsingForUsers(error: error)
    }

    // MARK: - Helpers

    private func connect(with peer: MCPeerID) {
        let newSession = createSession()
        browser.invitePeer(peer, to: newSession, withContext: nil, timeout: 2)
    }

    private func getSession(with userID: String) -> MCSession? {
        let session = sessions.first(where: { $0.connectedPeers.contains(where: { $0.displayName == userID }) })

        return session
    }

    private func getSession(with peer: MCPeerID) -> MCSession? {
        return sessions.first(where: { $0.connectedPeers.contains(peer) })
    }

    private func removeSession(with peer: MCPeerID) {
        if let session = getSession(with: peer) {
            sessions.remove(session)
        }
    }

    private func getUserName(from discoveryInfo: [String: String]?) -> String? {
        if let discovery = discoveryInfo, let name = discovery["userName"] {
            return name
        }
        return nil
    }
}
