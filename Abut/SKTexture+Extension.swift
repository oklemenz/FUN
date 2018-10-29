//
//  Background.swift
//  Abut
//
//  Created by Klemenz, Oliver on 17.07.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

public extension SKTexture {
    
    convenience init(size: CGFloat, color1: UIColor, color2: UIColor) {
        let size = CGSize(width: size, height: size)
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [color1.cgColor, color2.cgColor] as CFArray,
                                  locations: [0.0, 1.0])
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.drawRadialGradient(gradient!, startCenter: center, startRadius: 0, endCenter: center, endRadius: size.width, options: CGGradientDrawingOptions(rawValue: 0))
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        self.init(image: gradientImage!)
    }
}
