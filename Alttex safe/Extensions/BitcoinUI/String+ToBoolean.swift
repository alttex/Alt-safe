

import Foundation
/// An extenstion to the String Class Allowing it to convert a string representation of a boolean to the primative data type of Bool
extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}
