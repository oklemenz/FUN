//
//  DiceEye.swift
//  Abut
//
//  Created by Klemenz, Oliver on 19.07.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

class DiceEye : SKSpriteNode {
    
    static let diceEyeTexture: SKTexture = SKTexture(imageNamed: "dice_eye")
    
    init() {
        super.init(texture: DiceEye.diceEyeTexture, color: UIColor.white, size: DiceEye.diceEyeTexture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
