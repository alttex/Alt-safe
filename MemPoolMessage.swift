
import Foundation

public struct MemPoolMessage: MessagePayload {
    public init () {}
    
    public var command: Message.Command {
        return Message.Command.MemPool
    }
    
    public var bitcoinData: NSData {
        return NSData()
    }
    
    public static func fromBitcoinStream(_ stream: InputStream) -> MemPoolMessage? {
        return MemPoolMessage()
    }
}
