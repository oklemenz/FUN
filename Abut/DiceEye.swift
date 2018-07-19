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
    
    init() {
        let texture = SKTexture(imageNamed: "dice_eye")
        super.init(texture: texture, color: UIColor.white, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
