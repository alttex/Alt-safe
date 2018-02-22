//
//  WebVCActivityChrome.swift
//  Alttex safe
//
//  Created by Vlad Kovryzhenko on 2/7/18.
//  Copyright © 2018 Vlad Kovryzhenko. All rights reserved.
//

import Foundation
import UIKit

class SwiftWebVCActivityChrome : SwiftWebVCActivity {
    
    override var activityTitle : String {
        return NSLocalizedString("Open in Chrome", tableName: "SwiftWebVC", comment: "")
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        for activityItem in activityItems {
            if activityItem is URL, UIApplication.shared.canOpenURL(URL(string: "googlechrome://")!) {
                return true;
            }
        }
        return false;
    }
    
    override func perform() {
        let inputURL: URL! = URLToOpen as URL!
        let scheme: String! = inputURL.scheme
        
        // Replace the URL Scheme with the Chrome equivalent.
        var chromeScheme: String? = nil;
        if scheme == "http" {
            chromeScheme = "googlechrome"
        }
        else if scheme == "https" {
            chromeScheme = "googlechromes"
        }
        
        // Proceed only if a valid Google Chrome URI Scheme is available.
        if chromeScheme != nil {
            let absoluteString: NSString! = inputURL!.absoluteString as NSString!
            let rangeForScheme: NSRange! = absoluteString.range(of: ":")
            let urlNoScheme: String! = absoluteString.substring(from: rangeForScheme.location)
            let chromeURLString: String! = chromeScheme!+urlNoScheme
            let chromeURL: URL! = URL(string: chromeURLString)
            
            // Open the URL with Chrome.
            UIApplication.shared.openURL(chromeURL)
        }
    }
    
}
