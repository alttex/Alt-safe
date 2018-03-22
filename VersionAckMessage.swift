

import Foundation

public struct VersionAckMessage: MessagePayload {
    public var command: Message.Command {
        return Message.Command.VersionAck
    }
    
    public var bitcoinData: NSData {
        // A verack message has no payload.
        return NSData()
    }
    
    public static func fromBitcoinStream(_ stream: InputStream) -> VersionAckMessage? {
        // A verack message has no payload.
        return VersionAckMessage()
    }
}
