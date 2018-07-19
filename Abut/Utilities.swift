//
//  Utilities.swift
//  Abut
//
//  Created by Klemenz, Oliver on 17.07.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import UIKit

func randomInt(min: Int, max: Int) -> Int {
    return min + Int(arc4random_uniform(UInt32(max - min + 1)))
}

func randomDouble(min: Double, max: Double) -> Double {
    return (Double(arc4random()) / 0xFFFFFFFF) * (max - min) + min
}

func randomFloat(min: Float, max: Float) -> Float {
    return (Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
}

func randomCGFloat(min: CGFloat, max: CGFloat) -> CGFloat {
    return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (max - min) + min
}
