//
//  EndSpot.swift
//  Abut
//
//  Created by Klemenz, Oliver on 19.07.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

class EndSpot : SKNode {
    
    let radius: CGFloat = BALL_RADIUS
    let pattern: [CGFloat] = [BALL_RADIUS / 3.0, BALL_RADIUS / 3.0]
    
    var ring: SKShapeNode!
    var hLine: SKShapeNode!
    var vLine: SKShapeNode!
    
    override convenience init() {
        self.init(color: SKColor.white)
    }
    
    init(color: SKColor) {
        super.init()
        
        position = CGPoint(x: 0, y: 0)
        zPosition = 100
        
        ring = SKShapeNode()
        ring.path = CGPath(ellipseIn: CGRect(origin: CGPoint(x: -radius, y: -radius),
                                             size: CGSize(width: radius * 2, height: radius * 2)), transform: nil).copy(dashingWithPhase: 0, lengths: pattern)
        ring.strokeColor = SKColor.white
        ring.fillColor = SKColor.clear
        addChild(ring)
        animate()
        
        hLine = SKShapeNode()
        let hBezierPath = UIBezierPath()
        hBezierPath.move(to: CGPoint(x: -1.5 * radius, y: 0))
        hBezierPath.addLine(to: CGPoint(x: 1.5 * radius, y: 0))
        hLine.path = hBezierPath.cgPath.copy(dashingWithPhase: 0, lengths: pattern)
        addChild(hLine)
        
        vLine = SKShapeNode()
        let vBezierPath = UIBezierPath()
        vBezierPath.move(to: CGPoint(x: 0, y: -1.5 * radius))
        vBezierPath.addLine(to: CGPoint(x: 0, y: 1.5 * radius))
        vLine.path = vBezierPath.cgPath.copy(dashingWithPhase: 0, lengths: pattern)
        addChild(vLine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func animate() {
        let action = SKAction.rotate(byAngle: -CGFloat.pi * 2, duration: 10.0)
        ring.run(SKAction.repeatForever(action))
    }
}
