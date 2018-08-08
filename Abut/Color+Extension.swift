//
//  CIColor+Extension.swift
//  Abut
//
//  Created by Klemenz, Oliver on 17.07.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import CoreImage
import UIKit
import SpriteKit

public extension CIColor {
    
    convenience init(rgba: String) {
        let color = parseHexColor(rgba: rgba)
        self.init(red:color.red, green:color.green, blue:color.blue, alpha:color.alpha)
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red:r/255.0, green:g/255.0, blue:b/255.0)
    }
}

public extension SKColor {
    
    convenience init(rgba: String) {
        let color = parseHexColor(rgba: rgba)
        self.init(red:color.red, green:color.green, blue:color.blue, alpha:color.alpha)
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red:r/255.0, green:g/255.0, blue:b/255.0, alpha: 1.0)
    }
}

func parseHexColor(rgba: String) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var alpha: CGFloat = 1.0
    if rgba.hasPrefix("#") {
        let index = rgba.index(rgba.startIndex, offsetBy: 1)
        let hex = rgba[index...]
        let scanner = Scanner(string: String(hex))
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.count) {
            case 3:
                red = CGFloat((hexValue & 0xF00) >> 8) / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4) / 15.0
                blue = CGFloat(hexValue & 0x00F) / 15.0
            case 4:
                red = CGFloat((hexValue & 0xF000) >> 12) / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8) / 15.0
                blue = CGFloat((hexValue & 0x00F0) >> 4) / 15.0
                alpha = CGFloat(hexValue & 0x000F) / 15.0
            case 6:
                red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
                blue = CGFloat(hexValue & 0x0000FF) / 255.0
            case 8:
                red = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
                alpha = CGFloat(hexValue & 0x000000FF) / 255.0
            default:
                break
            }
        }
    }
    return (red: red, green: green, blue: blue, alpha: alpha)
}
