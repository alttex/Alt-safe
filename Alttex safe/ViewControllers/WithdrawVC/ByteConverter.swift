
import Foundation

func toByteArray<T>(_ value: T) -> [UInt8] {
    var data = [UInt8](repeating: 0, count: MemoryLayout<T>.size)
    data.withUnsafeMutableBufferPointer {
        UnsafeMutableRawPointer($0.baseAddress!).storeBytes(of: value, as: T.self)
    }
    return data
}
