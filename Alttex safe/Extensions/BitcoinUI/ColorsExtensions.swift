//
//  ColorsExtensions.swift
//  Alttex_messager
//
//  Created by Vlad Kovryzhenko on 1/16/18.
//  Copyright © 2018 Vlad Kovryzhenko. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    
    //#a6c675
    static func themeColor() -> UIColor {
        return UIColor(displayP3Red: 166 / 255, green: 198 / 255, blue: 117 / 255, alpha: 1.0)
        
    }
    
    static func boarderGray() -> UIColor {
        return UIColor(displayP3Red: 207 / 255, green: 209 / 255, blue: 216 / 255, alpha: 1.0)
    }
    
    
    static func sentRed() -> UIColor {
        return UIColor(displayP3Red: 227 / 255, green: 83 / 255, blue: 84 / 255, alpha: 1.0)
    }
    
    static func receivedGreen() -> UIColor {
        return UIColor(displayP3Red: 98 / 255, green: 236 / 255, blue: 131 / 255, alpha: 1.0)
    }
    
}
