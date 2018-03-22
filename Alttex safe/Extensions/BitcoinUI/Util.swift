

import Foundation
import UIKit


// Move the text field in a pretty animation!
func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool, viewController : UIViewController) {
    let moveDuration = 0.3
    let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
    
    UIView.beginAnimations("animateTextField", context: nil)
    UIView.setAnimationBeginsFromCurrentState(true)
    UIView.setAnimationDuration(moveDuration)
    viewController.view.frame = viewController.view.frame.offsetBy(dx: 0, dy: movement)
    UIView.commitAnimations()
}
