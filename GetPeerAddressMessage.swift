

import Foundation

public struct GetPeerAddressMessage: MessagePayload {
    
    public var command: Message.Command {
        return Message.Command.GetAddress
    }
    
    public var bitcoinData: NSData {
        return NSData()
    }
    
    public static func fromBitcoinStream(_ stream: InputStream) -> GetPeerAddressMessage? {
        return GetPeerAddressMessage()
    }
}
