//
//  ContactEffect.swift
//  Abut
//
//  Created by Klemenz, Oliver on 27.07.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

class CollisionEffect: SKNode {
    
    var context: SKNode!
    var contactPoint: CGPoint!
    var ballA: Ball!
    var ballB: Ball!
    
    var line: SKShapeNode!
    var cover: SKShapeNode!
    
    init(context: SKNode, contactPoint: CGPoint, ballA: Ball, ballB: Ball) {
        super.init()

        self.context = context
        self.contactPoint = contactPoint
        self.ballA = ballA
        self.ballB = ballB

        show()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func show() {
        if let contactEffect = SKEmitterNode(fileNamed: "CollisionEffect") {
            contactEffect.position = CGPoint(x: 0, y: 0)
            contactEffect.particleLifetime = 1.0
            contactEffect.particleColorSequence = SKKeyframeSequence(keyframeValues: [ballB.color, ballA.color], times: [0.0, 0.5])
            ballA.addChild(contactEffect)
            contactEffect.run(SKAction.sequence([
                SKAction.wait(forDuration: Double(contactEffect.particleLifetime)),
                SKAction.run {
                    contactEffect.particleBirthRate = 0
                },
                SKAction.wait(forDuration: Double(contactEffect.particleLifetime)),
                    SKAction.removeFromParent()
                ]))
        }
        
        let size = CGVector(dx: UIScreen.main.bounds.width, dy: UIScreen.main.bounds.height)
        let direction = (ballA.position - ballB.position).normalized()
        line = SKShapeNode()
        let bezierPath = UIBezierPath()
        bezierPath.move(to: contactPoint - direction * size.length())
        bezierPath.addLine(to: contactPoint + direction * size.length())
        line.zPosition = 1000
        line.path = bezierPath.cgPath
        line.lineWidth = 20
        line.glowWidth = 10
        line.strokeColor = ballA.color
        context.addChild(line)
        
        cover = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        cover.zPosition = 999
        cover.position = CGPoint(x: 0, y: 0)
        cover.alpha = 0.4
        cover.fillColor = ballA.color
        context.addChild(cover)
        
        animate()
    }
    
    func animate() {
        let action = SKAction.sequence([
            SKAction.repeat(SKAction.sequence([
                SKAction.wait(forDuration: 0.05),
                SKAction.run {
                    self.line.lineWidth -= 1
                    self.cover.alpha -= 0.03
                }
                ]), count: Int(self.line.lineWidth)),
            SKAction.removeFromParent()
        ])
        run(action, withKey: "pulse")
    }
}
