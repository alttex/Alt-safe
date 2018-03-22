

import Foundation

public func == (left: PongMessage, right: PongMessage) -> Bool {
    return left.nonce == right.nonce
}

public struct PongMessage: Equatable {
    
    public var nonce: UInt64
    
    public init(nonce: UInt64) {
        self.nonce = nonce
    }
}

extension PongMessage: MessagePayload {
    
    public var command: Message.Command {
        return Message.Command.Pong
    }
    
    public var bitcoinData: NSData {
        let data = NSMutableData()
        data.appendUInt64(nonce)
        return data
    }
    
    public static func fromBitcoinStream(_ stream: InputStream) -> PongMessage? {
        guard let nonce = stream.readUInt64() else {
            print("Failed to parse nonce fron PongMessage")
            return nil
        }
        return PongMessage(nonce: nonce)
    }
}
