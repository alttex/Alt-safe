

import Foundation

public class NetworkMagicBytes {
    //static let isMainNet = false
    
    public static func magicBytes() -> [UInt8] {
        if isBitcoinMainNet {
            return [0xf9, 0xbe, 0xb4, 0xd9]
        } else {
            return [0x0b, 0x11, 0x09, 0x07]
        }
    }
    
    static let checksumNum = 4
}
