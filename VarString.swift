

import Foundation

struct VarString {
    let length : VarInt
    let string : String?
    var bytes : [UInt8]
    
    public init(_ string: String?) {
        if string == nil {
            self.length = VarInt(0)
            self.bytes = [0x00]
        } else {
            self.length = VarInt(UInt64((string?.characters.count)!))
            self.bytes = length.bytes
            var characters = [UInt8]()
            for char in string!.utf8 {
                characters += [char]
            }
            self.bytes += characters
        }
        self.string = string
    }
}
