//
//  Block.swift
//  Abut
//
//  Created by Klemenz, Oliver on 11.09.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

class Block : SKShapeNode {
    
    let size: CGFloat = 2 * BALL_RADIUS
    
    var color = SKColor.black
    
    override init() {
        super.init()
        
        render()
        zPosition = 1
        
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size, height: size))
        physicsBody?.isDynamic = false
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.collisionBitMask = CollisionCategoryBlock
        physicsBody?.contactTestBitMask = CollisionCategoryBlock
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func render() {
        path = CGPath(rect: CGRect(x: -size / 2.0, y: size / 2.0, width: size, height: size), transform: nil)
        strokeColor = SKColor.clear
        color = SKColor.black
        fillColor = color
        glowWidth = 1
    }
    
    func save() -> [String:Any] {
        var data: [String:Any] = [:]
        data["x"] = position.x
        data["y"] = position.y
        return data
    }
    
    static func load(data: [String:Any]) -> Block {
        let block = Block()
        block.position = CGPoint(x: data["x"] as! CGFloat, y: data["y"] as! CGFloat)
        return block
    }
}
