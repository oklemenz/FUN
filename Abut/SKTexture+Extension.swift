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
    
    convenience init(size: CGFloat, color1: CIColor, color2: CIColor) {
        let context = CIContext(options: nil)
        let filter = CIFilter(name: "CIGaussianGradient")
        let inputCenter: CIVector = CIVector(x: size * 0.5, y: size * 0.5)
        filter!.setDefaults()
        filter!.setValue(inputCenter, forKey: "inputCenter")
        filter!.setValue(color1, forKey: "inputColor0")
        filter!.setValue(color2, forKey: "inputColor1")
        let image = context.createCGImage(filter!.outputImage!, from: CGRect(x: 0, y: 0, width: size, height: size))
        self.init(cgImage: image!)
    }
}
