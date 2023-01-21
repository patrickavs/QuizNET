//
//  MultipeerConnectivity.swift
//  GameDemo
//
//  Created by Patrick Alves on 28.11.22.
//

import Foundation
import MultipeerConnectivity
import os

public class Connectivity: NSObject, ObservableObject {
    @Published var availablePeers: [MCPeerID] = []
    @Published var receivedValue = ""
    @Published var receivedInvite: Bool = false
    @Published var receivedInviteFrom: MCPeerID? = nil
    @Published var paired: Bool = false
    @Published var invitationHandler: ((Bool, MCSession?) -> Void)?
    
    private let serviceType = "quiznet-service"
    private var myPeerID: MCPeerID
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser
    private let session: MCSession
    private let log = Logger()
    
    init(username: String) {
        let peerID = MCPeerID(displayName: username)
        self.myPeerID = peerID
        
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: serviceType)
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        
        super.init()
        
        session.delegate = self
        serviceAdvertiser.delegate = self
        serviceBrowser.delegate = self
        
        serviceAdvertiser.startAdvertisingPeer()
        serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }
    
    func changeUsername(userName: String) {
        self.myPeerID = MCPeerID(displayName: userName)
    }
    
    func browse() {
        serviceBrowser.startBrowsingForPeers()
    }
    
    func getSession() -> MCSession {
        return session
    }
    
    func getBrowser() -> MCNearbyServiceBrowser {
        return serviceBrowser
    }
    
    func getAdvertiser() -> MCNearbyServiceAdvertiser {
        return serviceAdvertiser
    }
    
    func advertise() {
        serviceAdvertiser.startAdvertisingPeer()
    }
    
    func send(data: String) {
        if !session.connectedPeers.isEmpty {
            do {
                try session.send(data.data(using: .utf8)!, toPeers: self.availablePeers, with: .reliable)
            } catch {
                print("Couldnt send data! Error: \(error)")
            }
        }
    }
}

extension Connectivity: MCNearbyServiceAdvertiserDelegate {
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        /// Let the User know that something went wrong and try again
        log.error("ServiceAdvertiser didNotStartAdvertisingPeer: \(String(describing: error))")
    }
    
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        log.info("didReceiveInvitationFromPeer \(peerID)")
        DispatchQueue.main.async {
            /// Tell PeerCollectionView to show the invitation alert
            self.receivedInvite = true
            /// Give PeerCollectionView the peerID of the peer who invited us
            self.receivedInviteFrom = peerID
            /// Give PeerCollectionView the `invitationHandler` so it can accept/deny the invitation
            self.invitationHandler = invitationHandler
        }
    }
}

extension Connectivity: MCNearbyServiceBrowserDelegate {
    public func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        log.error("ServiceBrowser didNotStartBrowsingForPeers: \(String(describing: error))")
    }
    
    public func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        log.info("ServiceBrowser found peer: \(peerID)")
        
        /// Add the peer to the list of available peers
        DispatchQueue.main.async {
            self.availablePeers.append(peerID)
        }
        
        //browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }
    
    public func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        log.info("ServiceBrowser lost peer: \(peerID)")
        DispatchQueue.main.async {
            self.availablePeers.removeAll(where: {
                $0 == peerID
            })
        }
    }
}

extension Connectivity: MCSessionDelegate {
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        log.info("peer \(peerID) didChangeState: \(state.rawValue)")
        switch state {
        case .connected:
            /// Peer connected
            DispatchQueue.main.async {
                self.paired = true
            }
            /// We are paired, stop accepting invitations
            serviceAdvertiser.stopAdvertisingPeer()
            break
        case .connecting:
            print("Connecting...")
        case .notConnected:
            // Peer disconnected
            DispatchQueue.main.async {
                self.paired = false
            }
            /// Peer disconnected, start accepting invitaions again
            serviceAdvertiser.startAdvertisingPeer()
            break
        default:
            /// Peer connecting or something else
            DispatchQueue.main.async {
                self.paired = false
            }
            break
        }
    }
    
    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let string = String(data: data, encoding: .utf8) {
            log.info("didReceive \(string) from \(peerID)")
        } else {
            log.info("didReceive invalid value \(data.count) bytes")
        }
    }
    
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        log.error("Receiving streams is not supported")
    }
    
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        log.error("Receiving resources is not supported")
    }
    
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        log.error("Receiving resources is not supported")
    }
}
