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
    return (Float(arc4random()) / Float(0xFFFFFFFF)) * (max - min) + min
}

func randomCGFloat(min: CGFloat, max: CGFloat) -> CGFloat {
    return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (max - min) + min
}

struct Device {

    static let IS_IPAD           = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE         = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA         = UIScreen.main.scale >= 2.0
    
    static let SCREEN_WIDTH      = Int(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT     = Int(UIScreen.main.bounds.size.height)
    static let SCREEN_MAX_LENGTH = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
    static let SCREEN_MIN_LENGTH = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
    
    static let DEVICE            = UIDevice.modelName;
    
    static let IS_IPHONE_4       = IS_IPHONE && SCREEN_MAX_LENGTH <= 480 // 2, 3, 3GS, 4, 4S
    static let IS_IPHONE_5       = IS_IPHONE && SCREEN_MAX_LENGTH == 568 // 5, 5S, 5C, SE
    static let IS_IPHONE_6       = IS_IPHONE && SCREEN_MAX_LENGTH == 667 // 6, 6S, 7, 8
    static let IS_IPHONE_6P      = IS_IPHONE && SCREEN_MAX_LENGTH == 736 // 6+, 6S+, 7+, 8+
    static let IS_IPHONE_X       = IS_IPHONE && SCREEN_MAX_LENGTH == 812 && !DEVICE.contains("mini")// X, XS, 11 Pro
    static let IS_IPHONE_11      = IS_IPHONE && SCREEN_MAX_LENGTH == 896 && !DEVICE.contains("Max") // XR, 11
    static let IS_IPHONE_11_MAX  = IS_IPHONE && SCREEN_MAX_LENGTH == 896 && DEVICE.contains("Max") // XS Max, 11 Pro Max
    static let IS_IPHONE_12_MINI = IS_IPHONE && SCREEN_MAX_LENGTH == 812 && DEVICE.contains("12 mini") // 12 Mini
    static let IS_IPHONE_12      = IS_IPHONE && SCREEN_MAX_LENGTH == 844 && DEVICE.contains("12") && !DEVICE.contains("Max") // 12, 12 Pro
    static let IS_IPHONE_12_MAX  = IS_IPHONE && SCREEN_MAX_LENGTH == 926 && DEVICE.contains("12 Pro Max") // 12 Pro Max
    static let IS_IPHONE_13      = IS_IPHONE && SCREEN_MAX_LENGTH == 844 && DEVICE.contains("13") && !DEVICE.contains("Max") // 13, 13 Pro
    static let IS_IPHONE_13_MAX  = IS_IPHONE && SCREEN_MAX_LENGTH == 926 && DEVICE.contains("13 Pro Max") // 13 Pro Max
    static let IS_IPHONE_13_MINI = IS_IPHONE && SCREEN_MAX_LENGTH == 812 && DEVICE.contains("13 mini") // 13 Mini
    static let IS_IPHONE_14      = IS_IPHONE && SCREEN_MAX_LENGTH == 844 && DEVICE.contains("14") // 14
    static let IS_IPHONE_14_PLUS = IS_IPHONE && SCREEN_MAX_LENGTH == 926 && DEVICE.contains("14") // 14 Plus
    static let IS_IPHONE_14_PRO  = IS_IPHONE && SCREEN_MAX_LENGTH == 852 && DEVICE.contains("14") // 14 Pro
    static let IS_IPHONE_14_MAX  = IS_IPHONE && SCREEN_MAX_LENGTH == 932 && DEVICE.contains("14") // 14 Pro Max
    static let IS_IPHONE_15      = IS_IPHONE && SCREEN_MAX_LENGTH == 844 && DEVICE.contains("15") // 15
    static let IS_IPHONE_15_PLUS = IS_IPHONE && SCREEN_MAX_LENGTH == 926 && DEVICE.contains("15") // 15 Plus
    static let IS_IPHONE_15_PRO  = IS_IPHONE && SCREEN_MAX_LENGTH == 852 && DEVICE.contains("15") // 15 Pro
    static let IS_IPHONE_15_MAX  = IS_IPHONE && SCREEN_MAX_LENGTH == 932 && DEVICE.contains("15") // 15 Pro Max
}
