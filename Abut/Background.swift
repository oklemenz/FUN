//
//  Background.swift
//  Abut
//
//  Created by Klemenz, Oliver on 30.07.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

class Background: SKSpriteNode {
    
    init() {
        let texture = SKTexture(size: UIScreen.main.bounds.width, color1: CIColor(rgba: "#116316"), color2: CIColor(rgba: "#0d3303"))
        super.init(texture: texture, color: UIColor.white, size: texture.size())
        
        zPosition = 0
        position = CGPoint(x: 0, y: 0)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
