//
//  StartSpot.swift
//  Abut
//
//  Created by Klemenz, Oliver on 17.07.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

class StartSpot : SKShapeNode {
    
    let radius: CGFloat = 25.0
    let pattern: [CGFloat] = [10.0, 10.0]
    
    override convenience init() {
        self.init(color: SKColor.white)
    }
    
    init(color: SKColor) {
        super.init()
        
        position = CGPoint(x: 0, y: 0)
        zPosition = 100
        
        path = CGPath(ellipseIn: CGRect(origin: CGPoint(x: -radius, y: -radius),
                                        size: CGSize(width: radius * 2, height: radius * 2)), transform: nil).copy(dashingWithPhase: 0, lengths: pattern)
        strokeColor = SKColor.white
        fillColor = SKColor.clear
        
        animate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func animate() {
        let action = SKAction.rotate(byAngle: -CGFloat.pi * 2, duration: 10.0)
        run(SKAction.repeatForever(action))
    }
}
