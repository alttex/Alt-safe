

import Foundation

class Currency {
    let name: String
    var checked = false
    
    
    init(name: String) {
        self.name = name
    }
    
    func toggleChecked() {
        checked = !checked
    }
}
