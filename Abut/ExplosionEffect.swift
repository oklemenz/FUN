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
    var node: SKNode!
    var color: UIColor!
    
    var cover: SKShapeNode!
    
    init(context: SKNode, ball: Ball) {
        super.init()

        self.context = context
        self.node = ball
        self.color = ball.color

        show()
    }
    
    init(context: SKNode, block: Block) {
        super.init()
        
        self.context = context
        self.node = block
        self.color = .black
        
        show()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func show() {
        if let explosionEffect = SKEmitterNode(fileNamed: "ExplosionEffect") {
            explosionEffect.position = node.position
            explosionEffect.particleColor = color
            explosionEffect.particleColorSequence = SKKeyframeSequence(keyframeValues: [color!], times: [0.0])
            explosionEffect.particleLifetime = 0.5
            explosionEffect.zPosition = 10
            context.addChild(explosionEffect)
            explosionEffect.run(SKAction.sequence([
                SKAction.wait(forDuration: Double(explosionEffect.particleLifetime)),
                SKAction.run {
                    explosionEffect.particleBirthRate = 0
                },
                SKAction.wait(forDuration: Double(explosionEffect.particleLifetime)),
                    SKAction.removeFromParent()
                ]))
        }
        
        cover = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        cover.zPosition = 999
        cover.position = CGPoint(x: 0, y: 0)
        cover.alpha = 0.4
        cover.fillColor = color
        context.parent!.addChild(cover)
        
        animate()
    }
    
    func animate() {
        let startAlpha = cover.alpha
        let repeatCount = 20
        let action = SKAction.sequence([
            SKAction.repeat(SKAction.sequence([
                SKAction.wait(forDuration: 0.05),
                SKAction.run {
                    self.cover.alpha -= startAlpha / CGFloat(repeatCount)
                }
                ]), count: repeatCount),
            SKAction.run({
                self.cover.removeFromParent()
            }),
            SKAction.removeFromParent()
        ])
        run(action, withKey: "hide")
    }
}
