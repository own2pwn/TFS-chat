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

    let localPeerID: String

    var delegate: CommunicatorDelegate?

    var isOnline: Bool = false {
        didSet { setOnline(isOnline) }
    }

    // MARK: - Members

    private var sessions = [String: MCSession]()

    private var pendingSessions = [String: MCSession]()

    private let me: MCPeerID

    private let advertiser: MCNearbyServiceAdvertiser

    private let browser: MCNearbyServiceBrowser

    // MARK: - Init

    override init() {
        me = MultipeerCommunicatorImp.loadOrCreatePeer()
        advertiser = MultipeerCommunicatorImp.makeAdvertiser(for: me)
        browser = MultipeerCommunicatorImp.makeBrowser(for: me)
        localPeerID = me.displayName

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
            let peersToSend = session.connectedPeers.filter { $0.displayName != localPeerID }
            try session.send(serialized, toPeers: peersToSend, with: .reliable)
            completion?(true, nil)
            delegate?.didSendMessage(text: message, fromUser: localPeerID, toUser: userID)
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

    private func createSession(for peerID: MCPeerID) -> MCSession {
        let newSession = MCSession(peer: me, securityIdentity: nil, encryptionPreference: .none)
        newSession.delegate = self

        sessions[peerID.displayName] = newSession

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

        if let peerData = defaults.value(forKey: peerKey) as? Data,
            let savedPeer = NSKeyedUnarchiver.unarchiveObject(with: peerData) as? MCPeerID {
            return savedPeer
        }
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
        if let pending = pendingSessions.removeValue(forKey: peerID.displayName) {
            invitationHandler(true, pending)
            return
        }

        guard !isSessionExists(with: peerID) else {
            invitationHandler(false, nil)
            return
        }
        let newSession = createSession(for: peerID)
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
        if let existing = getSession(with: peer) {
            browser.invitePeer(peer, to: existing, withContext: nil, timeout: 2)
            pendingSessions[peer.displayName] = existing
        } else {
            let newSession = createSession(for: peer)
            browser.invitePeer(peer, to: newSession, withContext: nil, timeout: 2)
            pendingSessions[peer.displayName] = newSession
        }
    }

    private func getSession(with userID: String) -> MCSession? {
        let session = sessions.first(where: { $0.value.connectedPeers.contains(where: { $0.displayName == userID }) })

        return session?.value
    }

    private func getSession(with peer: MCPeerID) -> MCSession? {
        return sessions[peer.displayName]
    }

    private func removeSession(with peer: MCPeerID) {
        sessions.removeValue(forKey: peer.displayName)
    }

    private func getUserName(from discoveryInfo: [String: String]?) -> String? {
        if let discovery = discoveryInfo, let name = discovery["userName"] {
            return name
        }
        return nil
    }
}
