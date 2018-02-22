//
//  ColorExtension.swift
//  Alttex safe
//
//  Created by Vlad Kovryzhenko on 2/8/18.
//  Copyright © 2018 Vlad Kovryzhenko. All rights reserved.
//

import Foundation
import UIKit

struct GlobalVariables {
    static let blue = UIColor.rbg(r: 129, g: 144, b: 255)
    static let white = UIColor.rbg(r: 255, g: 255, b: 255)
    static let customGray = UIColor.rbg(r: 34, g: 34, b: 34)
    static let customBlack = UIColor.rbg(r: 24, g: 24, b: 24)
}

//Extensions
extension UIColor{
    class func rbg(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        let color = UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
        return color
    }
}
