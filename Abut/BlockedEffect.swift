//
//  BlockedEffect.swift
//  Abut
//
//  Created by Klemenz, Oliver on 24.09.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

class BlockedEffect: SKNode {
    
    var context: SKNode!
    var contactPosition: CGPoint!
    
    var cover: SKShapeNode!
    
    init(context: SKNode, contactPoint: CGPoint) {
        super.init()
        
        self.context = context
        self.contactPosition = contactPoint
        
        show()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func show() {
        if let contactEffect = SKEmitterNode(fileNamed: "BlockedEffect") {
            contactEffect.position = contactPosition
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
        cover.fillColor = .black
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
