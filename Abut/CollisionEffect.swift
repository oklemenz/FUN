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
    var ballA: Ball!
    var ballB: Ball!
    
    var line: SKShapeNode!
    var cover: SKShapeNode!
    
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
        if let collisionEffect = SKEmitterNode(fileNamed: "CollisionEffect") {
            collisionEffect.position = CGPoint(x: 0, y: 0)
            collisionEffect.particleLifetime = 0.5
            collisionEffect.particleColorSequence = SKKeyframeSequence(keyframeValues: [ballB.color, ballA.color], times: [0.0, 0.5])
            ballA.addChild(collisionEffect)
            collisionEffect.run(SKAction.sequence([
                SKAction.wait(forDuration: Double(collisionEffect.particleLifetime)),
                SKAction.run {
                    collisionEffect.particleBirthRate = 0
                },
                SKAction.wait(forDuration: Double(collisionEffect.particleLifetime)),
                    SKAction.removeFromParent()
                ]))
        }
        
        let size = CGVector(dx: UIScreen.main.bounds.width, dy: UIScreen.main.bounds.height)
        let direction = (ballA.position - ballB.position).normalized()
        let point = ballA.position.middleTo(ballB.position)
        line = SKShapeNode()
        let bezierPath = UIBezierPath()
        bezierPath.move(to: point - direction * size.length())
        bezierPath.addLine(to: point + direction * size.length())
        line.zPosition = 1000
        line.path = bezierPath.cgPath
        line.lineWidth = 20
        line.glowWidth = 10
        line.strokeColor = ballA.color
        context.parent!.addChild(line)
        
        cover = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        cover.zPosition = 999
        cover.position = CGPoint(x: 0, y: 0)
        cover.alpha = 0.4
        cover.fillColor = ballA.color
        context.parent!.addChild(cover)
        
        animate()
    }
    
    func animate() {
        let startAlpha = cover.alpha
        let repeatCount = line.lineWidth
        let action = SKAction.sequence([
            SKAction.repeat(SKAction.sequence([
                SKAction.wait(forDuration: 0.05),
                SKAction.run {
                    self.line.lineWidth -= 1
                    self.cover.alpha -= startAlpha / repeatCount
                }
                ]), count: Int(repeatCount)),
            SKAction.run({
                self.line.removeFromParent()
                self.cover.removeFromParent()
            }),
            SKAction.removeFromParent()
        ])
        run(action, withKey: "pulse")
    }
}
