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

struct Device {
    static let IS_IPAD             = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE           = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA           = UIScreen.main.scale >= 2.0
    
    static let SCREEN_WIDTH        = Int(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT       = Int(UIScreen.main.bounds.size.height)
    static let SCREEN_MAX_LENGTH   = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
    static let SCREEN_MIN_LENGTH   = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
    
    static let NATIVE_WIDTH        = Int(UIScreen.main.nativeBounds.width)
    static let NATIVE_HEIGHT       = Int(UIScreen.main.nativeBounds.height)
    static let NATIVE_MAX_LENGTH   = Int( max(NATIVE_WIDTH, NATIVE_HEIGHT) )
    static let NATIVE_MIN_LENGTH   = Int( min(NATIVE_WIDTH, NATIVE_HEIGHT) )
    
    static let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH  < 568
    static let IS_IPHONE_5         = IS_IPHONE && SCREEN_MAX_LENGTH == 568
    static let IS_IPHONE_6         = IS_IPHONE && SCREEN_MAX_LENGTH == 667
    static let IS_IPHONE_6P        = IS_IPHONE && SCREEN_MAX_LENGTH == 736
    static let IS_IPHONE_X         = IS_IPHONE && (SCREEN_MAX_LENGTH == 812 || SCREEN_MAX_LENGTH == 896)
    static let IS_IPHONE_XR        = IS_IPHONE && SCREEN_MAX_LENGTH == 896 && NATIVE_MAX_LENGTH == 1792
}
