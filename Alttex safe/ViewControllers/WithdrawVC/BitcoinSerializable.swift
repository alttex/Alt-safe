

import Foundation

public protocol BitcoinSerializable {
    var bitcoinData: NSData { get }
    
    static func fromBitcoinStream(_ stream: InputStream) -> Self?
}
