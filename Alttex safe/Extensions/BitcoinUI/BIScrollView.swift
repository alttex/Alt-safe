

import UIKit

class BIScrollView: UIScrollView {
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIButton {
            return  true
        }
        return  super.touchesShouldCancel(in: view)
    }
    
}
