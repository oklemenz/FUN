//
//  Ball.swift
//  Abut
//
//  Created by Klemenz, Oliver on 17.07.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

let CollisionCategoryDefault: UInt32 = 0x1 << 0
let CollisionCategoryBall: UInt32 = 0x1 << 1

class Ball : SKShapeNode {
    
    let radius: CGFloat = 16.0
    
    var value = 1
    
    override convenience init() {
        self.init(color: SKColor.white)
    }
    
    init(color: SKColor) {
        super.init()
        
        zPosition = 1
        
        path = CGPath(ellipseIn: CGRect(origin: CGPoint(x: -radius, y: -radius),
                                        size: CGSize(width: radius * 2, height: radius * 2)), transform: nil)
        strokeColor = SKColor.clear
        fillColor = color
        
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody?.restitution = 1
        physicsBody?.linearDamping = 10
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.collisionBitMask = CollisionCategoryBall
        physicsBody?.contactTestBitMask = CollisionCategoryBall
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func shoot(vector: CGVector) {
        physicsBody?.applyImpulse(vector)
    }
    
    func rollIn() {
        let width = UIScreen.main.bounds.width;
        let height = UIScreen.main.bounds.height;
        let side = randomInt(min: 1, max: 4)
        let fx = randomCGFloat(min: 100, max: 500)
        let fy = randomCGFloat(min: 100, max: 500)
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        var dx: CGFloat = 0
        var dy: CGFloat = 0
        print(side)
        switch (side) {
            case 1:
                x = randomCGFloat(min: -width/2 + radius, max: width/2 - radius)
                y = height/2 - radius
                dx = x < 0 ? 1 : -1
                dy = -1
            case 2:
                x = width/2 - radius
                y = randomCGFloat(min: -height/2 + radius, max: height/2 - radius)
                dx = -1
                dy = y < 0 ? 1 : -1
            case 3:
                x = randomCGFloat(min: -width/2 + radius, max: width/2 - radius)
                y = -height/2 + radius
                dx = x < 0 ? 1 : -1
                dy = 1
            case 4:
                x = -width/2 + radius
                y = randomCGFloat(min: -height/2 + radius, max: height/2 - radius)
                dx = 1
                dy = y < 0 ? 1 : -1
            default:
                x = 0
                y = 0
        }
        position = CGPoint(x: x, y: y)
        shoot(vector: CGVector(dx: dx * fx, dy: dy * fy))
    }
}
