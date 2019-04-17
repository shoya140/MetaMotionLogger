//
//  UIColor+Hex.swift
//  MetaMotionLogger
//
//  Created by Shoya Ishimaru on 2019.04.17.
//  Copyright © 2019 shoya140. All rights reserved.
//

import UIKit

extension UIColor {
    class func hex (code : NSString, alpha : CGFloat) -> UIColor {
        let code = code.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: code as String)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            print("invalid hex string")
            return UIColor.white
        }
    }
}
