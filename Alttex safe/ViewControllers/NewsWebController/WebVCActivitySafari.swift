//
//  WebVCActivitySafari.swift
//  Alttex safe
//
//  Created by Vlad Kovryzhenko on 2/7/18.
//  Copyright © 2018 Vlad Kovryzhenko. All rights reserved.
//

import Foundation
import UIKit

class SwiftWebVCActivitySafari : SwiftWebVCActivity {
    
    override var activityTitle : String {
        return NSLocalizedString("Open in Safari", tableName: "SwiftWebVC", comment: "")
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        for activityItem in activityItems {
            if let activityItem = activityItem as? URL, UIApplication.shared.canOpenURL(activityItem) {
                return true
            }
        }
        return false
    }
    
    override func perform() {
        let completed: Bool = UIApplication.shared.openURL(URLToOpen! as URL)
        activityDidFinish(completed)
    }
    
}
