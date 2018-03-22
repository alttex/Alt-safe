
import Foundation
import RealmSwift

class TransactionOutPointInfo: Object {
    @objc dynamic var txHash = ""
    @objc dynamic var index: Int = 0
    let inputs = LinkingObjects(fromType: TransactionInputInfo.self, property: "outPoint")
    var inverse_input: TransactionInputInfo? { return inputs.first }
    
    public static func create(_ outpoint: Transaction.OutPoint) -> TransactionOutPointInfo {
        let txOutpoint = TransactionOutPointInfo()
        txOutpoint.txHash = outpoint.transactionHash.data.toHexString()
        txOutpoint.index = Int(outpoint.index)
        return txOutpoint
    }
}
