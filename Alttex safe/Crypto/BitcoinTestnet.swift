
import Foundation

public class BitcoinTestnet : CoinKey {
    public init() {
        super.init(privateKeyPrefix: 0xef, publicKeyPrefix: 0x6f)
    }
    
    public init(privateKeyHex: String) {
        super.init(privateKeyHex: privateKeyHex, privateKeyPrefix: 0xef, publicKeyPrefix: 0x6f, skipPublicKeyGeneration: false, isCompressedPublicKeyAddress: true)
    }
    
    public init(privateKeyHex: String, publicKeyHex: String) {
        super.init(privateKeyHex: privateKeyHex, publicKeyHex: publicKeyHex, privateKeyPrefix: 0xef, publicKeyPrefix: 0x6f, isCompressedPublicKeyAddress: true)
    }
    
    public init?(wif: String) {
        
        let wif_candidate = Wif(privateKeyPrefix: 0xef)
        if wif_candidate.importWif(wif) {
            super.init(privateKeyHex: wif_candidate.privateKeyHexString, privateKeyPrefix: 0xef, publicKeyPrefix: 0x6f, skipPublicKeyGeneration: false, isCompressedPublicKeyAddress: wif_candidate.isCompressedPublicKey)
        
        } else {
            return nil
        }
    }
}
