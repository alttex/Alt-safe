

import Foundation

public class PeerAddressDataStoreManager {
    
    public static func add(peerAddressMessage: PeerAddressMessage) {
        for peerAddress in peerAddressMessage.peerAddresses {
            if let addressString = peerAddress.IP.addressString {
                let nodeInfo = NodeInfo.create(addressString, Int(peerAddress.port))
                nodeInfo.save()
                print("Address: \(addressString) saved")
            }
        }
    }
}
