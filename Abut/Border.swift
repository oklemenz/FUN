//
//  Border.swift
//  Abut
//
//  Created by Klemenz, Oliver on 30.07.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

class Border : SKNode {
    
    let WIDTH: CGFloat = 50
    
    override init() {
        super.init()
        
        top()
        bottom()
        left()
        right()
    }

    func top() {
        let size = CGSize(width: UIScreen.main.bounds.width + 2 * WIDTH, height: WIDTH)
        let top = SKShapeNode(rectOf: size)
        top.zPosition = 0.1
        top.fillColor = .clear
        top.strokeColor = .clear
        top.physicsBody = SKPhysicsBody(rectangleOf: size)
        top.physicsBody?.isDynamic = false
        top.physicsBody?.usesPreciseCollisionDetection = true
        top.position = CGPoint(x: 0, y: (UIScreen.main.bounds.height + WIDTH) / 2.0)
        addChild(top)
    }
    
    func bottom() {
        let size = CGSize(width: UIScreen.main.bounds.width + 2 * WIDTH, height: WIDTH)
        let bottom = SKShapeNode(rectOf: size)
        bottom.zPosition = 0.1
        bottom.fillColor = .clear
        bottom.strokeColor = .clear
        bottom.physicsBody = SKPhysicsBody(rectangleOf: size)
        bottom.physicsBody?.isDynamic = false
        bottom.physicsBody?.usesPreciseCollisionDetection = true
        bottom.position = CGPoint(x: 0, y: -(UIScreen.main.bounds.height + WIDTH) / 2.0)
        addChild(bottom)
    }
    
    func left() {
        let size = CGSize(width: WIDTH, height: UIScreen.main.bounds.height + 2 * WIDTH)
        let left = SKShapeNode(rectOf: size)
        left.zPosition = 0.1
        left.fillColor = .red
        left.strokeColor = .clear
        left.physicsBody = SKPhysicsBody(rectangleOf: size)
        left.physicsBody?.isDynamic = false
        left.physicsBody?.usesPreciseCollisionDetection = true
        left.position = CGPoint(x: -(UIScreen.main.bounds.width + WIDTH) / 2.0, y: 0)
        addChild(left)
    }
    
    func right() {
        let size = CGSize(width: WIDTH, height: UIScreen.main.bounds.height + 2 * WIDTH)
        let right = SKShapeNode(rectOf: size)
        right.zPosition = 0.1
        right.fillColor = .red
        right.strokeColor = .clear
        right.physicsBody = SKPhysicsBody(rectangleOf: size)
        right.physicsBody?.isDynamic = false
        right.physicsBody?.usesPreciseCollisionDetection = true
        right.position = CGPoint(x: (UIScreen.main.bounds.width + WIDTH) / 2.0, y: 0)
        addChild(right)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
