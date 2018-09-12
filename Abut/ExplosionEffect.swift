//
//  ContactEffect.swift
//  Abut
//
//  Created by Klemenz, Oliver on 27.07.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

class ExplosionEffect: SKNode {
    
    var context: SKNode!
    var ball: Ball!
    
    var cover: SKShapeNode!
    
    init(context: SKNode, ball: Ball) {
        super.init()

        self.context = context
        self.ball = ball

        show()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func show() {
        if let contactEffect = SKEmitterNode(fileNamed: "ExplosionEffect") {
            contactEffect.position = ball.position
            contactEffect.particleColor = ball.color
            contactEffect.particleColorSequence = SKKeyframeSequence(keyframeValues: [ball.color], times: [0.0])
            contactEffect.particleLifetime = 0.5
            contactEffect.zPosition = 10
            context.addChild(contactEffect)
            contactEffect.run(SKAction.sequence([
                SKAction.wait(forDuration: Double(contactEffect.particleLifetime)),
                SKAction.run {
                    contactEffect.particleBirthRate = 0
                },
                SKAction.wait(forDuration: Double(contactEffect.particleLifetime)),
                    SKAction.removeFromParent()
                ]))
        }
        
        cover = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        cover.zPosition = 999
        cover.position = CGPoint(x: 0, y: 0)
        cover.alpha = 0.4
        cover.fillColor = ball.color
        context.addChild(cover)
        
        animate()
    }
    
    func animate() {
        let action = SKAction.sequence([
            SKAction.repeat(SKAction.sequence([
                SKAction.wait(forDuration: 0.05),
                SKAction.run {
                    self.cover.alpha -= 0.03
                }
                ]), count: 20),
            SKAction.removeFromParent()
        ])
        run(action, withKey: "hide")
    }
}
