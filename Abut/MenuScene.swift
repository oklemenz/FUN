//
//  MenuScene.swift
//  Abut
//
//  Created by Klemenz, Oliver on 10.09.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: SKNode {
    
    var screen: SKShapeNode!
    
    override init() {
        super.init()
        
        isUserInteractionEnabled = true

        let w = UIScreen.main.bounds.width
        let w2 = w / 2.0
        let h = UIScreen.main.bounds.height
        let h2 = h / 2.0
        
        let screenPath = UIBezierPath(roundedRect: CGRect(x: -w2, y: -h2, width: w, height: h), cornerRadius: CORNER_RADIUS)
        screen = SKShapeNode()
        screen.path = screenPath.cgPath
        screen.zPosition = 1000000
        screen.fillColor = .black
        screen.strokeColor = .clear
        screen.position = CGPoint(x: 0, y: 0)
        screen.alpha = 0.75
        addChild(screen)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        run(SKAction.fadeOut(withDuration: 0.5))
    }
}
