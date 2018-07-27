//
//  ContactEffect.swift
//  Abut
//
//  Created by Klemenz, Oliver on 27.07.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

class ContactEffect: SKNode {
    
    var context: SKNode!
    var ballA: Ball!
    var ballB: Ball!
    
    var line: SKShapeNode!
    
    init(context: SKNode, ballA: Ball, ballB: Ball) {
        super.init()

        self.context = context
        self.ballA = ballA
        self.ballB = ballB

        show()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func show() {
        if let contactEffect = SKEmitterNode(fileNamed: "ContactEffect") {
            contactEffect.position = CGPoint(x: 0, y: 0)
            contactEffect.particleLifetime = 1.0
            contactEffect.particleColorSequence = SKKeyframeSequence(keyframeValues: [ballB.color, ballA.color], times: [0.0, 0.5])
            ballA.addChild(contactEffect)
            run(SKAction.sequence([
                SKAction.wait(forDuration: Double(contactEffect.particleLifetime)),
                SKAction.run {
                    contactEffect.particleBirthRate = 0
                },
                SKAction.wait(forDuration: Double(contactEffect.particleLifetime)),
                //SKAction.removeFromParent()
                ]))
        }
        
        let size = CGVector(dx: UIScreen.main.bounds.width, dy: UIScreen.main.bounds.height)
        let direction = (ballA.position - ballB.position).normalized()
        line = SKShapeNode()
        let bezierPath = UIBezierPath()
        bezierPath.move(to: ballA.position - direction * size.length())
        bezierPath.addLine(to: ballA.position + direction * size.length())
        line.zPosition = 1000
        line.path = bezierPath.cgPath
        line.lineWidth = 10
        line.strokeColor = ballA.color
        self.context.addChild(line)
        
        animateLine(line: line)
    }
    
    func animateLine(line: SKShapeNode) {
        var update:CGFloat = 1.0
        let action = SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: 0.05),
            SKAction.run {
                line.lineWidth += update
                if line.lineWidth > 15 {
                    update = -1
                }
                if line.lineWidth == 0 {
                    self.removeAction(forKey: "pulse")
                }
            }
        ]))
        line.run(action, withKey: "pulse")
    }
}
