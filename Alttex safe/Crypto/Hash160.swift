
import Foundation

public struct Hash160 {
    public static func digest(_ input: NSData) -> NSData {
        let sha256 = SHA256.digest(input)
        let ripemd : NSData = RIPEMD.digest(sha256)
        return ripemd
    }
    
    public static func hexStringDigest(_ hexStr: String) -> NSData {
        let sha256 : NSData = SHA256.hexStringDigest(hexStr)
        let rimemd : NSData = RIPEMD.digest(sha256)
        return rimemd
    }
    
    public static func digestHexString(_ input : NSData) -> String {
        return digest(input).toHexString()
    }
    
    public static func hexStringDigestHexString(_ hexStr : String) -> String {
        return hexStringDigest(hexStr).toHexString() 
    }
    
}
