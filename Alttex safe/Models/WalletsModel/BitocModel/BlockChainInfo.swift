

import Foundation
import RealmSwift


public class BlockChainInfo: Object {
    static let realm = try! Realm()
    
    @objc dynamic var genesisCreated: Bool = false
    
    @objc dynamic var lastBlockHash = ""
    @objc dynamic var lastBlockHeight = 0
    
    public static func loadItem() -> BlockChainInfo? {
        return realm.objects(BlockChainInfo.self).first
    }
    
    public func save() {
        try! BlockChainInfo.realm.write {
            BlockChainInfo.realm.add(self)
        }
    }
    
    public func update(_ method: (() -> Void)) {
        try! BlockChainInfo.realm.write {
            method()
        }
    }
}
