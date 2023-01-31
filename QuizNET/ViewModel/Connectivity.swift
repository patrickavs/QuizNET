//
//  MultipeerConnectivity.swift
//  GameDemo
//
//  Created by Patrick Alves on 28.11.22.
//

import Foundation
import MultipeerConnectivity
import os

/// Connectivity-Class to handle the peer-to-peer connectivity
public class Connectivity: NSObject, ObservableObject {
    @Published var availablePeers: [MCPeerID] = []
    @Published var receivedValue = ""
    @Published var receivedInvite: Bool = false
    @Published var receivedInviteFrom: MCPeerID? = nil
    @Published var paired: Bool = false
    @Published var invitationHandler: ((Bool, MCSession?) -> Void)?
    @Published var hideStartButton = false
    @Published var personalPlayerName = ""
    @Published var disconnectedMessage = ""
    @Published var disconnectedAlert = false
    //@Published var retryAlert = false
    
    let serviceType = "quiznet-service"
    private var myPeerID: MCPeerID
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    var serviceBrowser: MCNearbyServiceBrowser
    private var session: MCSession
    private let log = Logger()
    
    /// Initialize all the properties
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
    }
    
    /// When this object is deallocated, the device will stop advertising itself and stop browsing for another peers
    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }
    
    // MARK: I tried to give the user the chance to choose a username, but this didnt work yet
    /// Set the username for the device, which can be seen for others if the device advertises itself
    /// - Parameter userName: Username for the device
    func setUsername(userName: String) {
        self.personalPlayerName = userName
    }
    
    /// The device starts to browse for other peers
    func browse() {
        serviceBrowser.startBrowsingForPeers()
    }
    
    /// Get the current session
    /// - Returns: Returns the current session
    func getSession() -> MCSession {
        return session
    }
    
    /// Get the current servicebrowser
    /// - Returns: Returns the current servicebrowser
    func getBrowser() -> MCNearbyServiceBrowser {
        return serviceBrowser
    }
    
    /// Get the current serviceadvertiser
    /// - Returns: Returns the current serviceadvertiser
    func getAdvertiser() -> MCNearbyServiceAdvertiser {
        return serviceAdvertiser
    }
    
    /// The device starts to advertise, that it can be detected by other devices
    func advertise() {
        serviceAdvertiser.startAdvertisingPeer()
    }
    
    /// Send the data you give to the function to all connected peers in the current session
    func send(data: String) {
        if !session.connectedPeers.isEmpty {
            do {
                try session.send(data.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
            } catch {
                print("Couldnt send data! Error: \(error)")
            }
        }
    }
}

/// Connectivity extension, which advertises the device to other devices in the local network
extension Connectivity: MCNearbyServiceAdvertiserDelegate {
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        /// Let the User know that something went wrong and try again
        log.error("ServiceAdvertiser didNotStartAdvertisingPeer: \(String(describing: error))")
    }
    
    /// This function handles invitations from other peers
    /// - Parameters:
    ///   - advertiser: Current MCNearbyServiceAdvertiser
    ///   - peerID: The Peer, which should be advertised
    ///   - context: Optional context
    ///   - invitationHandler: Give PeerCollectionView the `invitationHandler` so it can accept/deny the invitation
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        log.info("didReceiveInvitationFromPeer \(peerID)")
        DispatchQueue.main.async {
            /// Tell PeerCollectionView to show the invitation alert
            self.receivedInvite = true
            /// Give PeerCollectionView the peerID of the peer who invited us
            self.receivedInviteFrom = peerID
            self.invitationHandler = invitationHandler
        }
    }
}

extension Connectivity: MCNearbyServiceBrowserDelegate {
    /// This function handles browsing errors
    /// - Parameters:
    ///   - browser: Current NearbyServiceBrowser
    ///   - error: Error description
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
            break
        case .notConnected:
            /// Peer disconnected
            DispatchQueue.main.async {
                self.paired = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { [self] in
                /// Disconnected alert
                disconnectedAlert = true
                /// Disconnected message
                disconnectedMessage = "\(peerID.displayName) is disconnected!"
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
    
    /// Handles received data from other peers
    /// - Parameters:
    ///   - session: Current MCSession
    ///   - data: Data that was sent by another device
    ///   - peerID: Peer that sent the data
    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let string = String(data: data, encoding: .utf8) {
            log.info("didReceive \(string) from \(peerID)")
            DispatchQueue.main.async {
                self.receivedValue = string
            }
        } else {
            log.info("didReceive invalid value \(data.count) bytes")
        }
    }
    
    /// Notify this device that an Inputstream was received from another device
    /// - Parameters:
    ///   - session: Current MCSession
    ///   - stream: Received InputStream
    ///   - streamName: Name of the stream
    ///   - peerID: Peer that sent the data
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        log.error("Receiving streams is not supported")
    }
    
    /// This function is called when the device received a resource
    /// - Parameters:
    ///   - session: Current MCSession
    ///   - resourceName: Resource name
    ///   - peerID: Peer that sent the resource
    ///   - progress: Progress description
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        log.error("Receiving resources is not supported")
    }
    
    /// This function is called when the device finished receiving resources
    /// - Parameters:
    ///   - session: Current MCSession
    ///   - resourceName: Resource name
    ///   - peerID: peerID from the sending device
    ///   - localURL: URL from the resource
    ///   - error: Error description
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        log.error("Receiving resources is not supported")
    }
}
