

import Foundation

public class BitcoinPrefixes {
    
    public static var privatePrefix: UInt8 {
        if isBitcoinMainNet {
            return 0x80
        } else {
            return 0xef
        }
    }
    
    public static var pubKeyPrefix: UInt8 {
        if isBitcoinMainNet {
            return 0x00
        } else {
            return 0x6f
        }
    }
    
    public static var scriptHashPrefix: UInt8 {
        if isBitcoinMainNet {
            return 0x05
        } else {
            return 0xc4
        }
    }
    
}
