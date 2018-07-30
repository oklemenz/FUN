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
    
    var color = SKColor.white
    var value = 1 {
        didSet {
            render()
        }
    }

    static func White() -> Ball {
        return Ball(value: 0)
    }
    
    override convenience init() {
        self.init(value: 1)
    }
    
    init(value: Int) {
        super.init()
        
        self.value = value
        render()
        
        zPosition = 1
        
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody?.restitution = 0.8
        physicsBody?.linearDamping = 2
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.collisionBitMask = CollisionCategoryBall
        physicsBody?.contactTestBitMask = CollisionCategoryBall
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func increase() {
        value += 1
    }
    
    func render() {
        switch value {
            case 1:
                color = SKColor(r: 255, g: 59, b: 48)
            case 2:
                color = SKColor(r: 255, g: 149, b: 0)
            case 3:
                color = SKColor(r: 255, g: 204, b: 0)
            case 4:
                color = SKColor(r: 76, g: 217, b: 100)
            case 5:
                color = SKColor(r: 90, g: 200, b: 250)
            case 6:
                color = SKColor(r: 0, g: 122, b: 255)
            case 7:
                color = SKColor(r: 88, g: 86, b: 214)
            case 8:
                color = SKColor(r: 255, g: 45, b: 85)
            default:
                color = .white
        }
        path = CGPath(ellipseIn: CGRect(origin: CGPoint(x: -radius, y: -radius),
                                        size: CGSize(width: radius * 2, height: radius * 2)), transform: nil)
        strokeColor = SKColor.clear
        fillColor = color
    }
   
    func shoot(vector: CGVector) {
        physicsBody?.applyImpulse(vector)
    }
    
    func roll() {
        let width = UIScreen.main.bounds.width;
        let height = UIScreen.main.bounds.height;
        let side = randomInt(min: 1, max: 4)
        let fx = randomCGFloat(min: 10, max: 100)
        let fy = randomCGFloat(min: 10, max: 100)
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        var dx: CGFloat = 0
        var dy: CGFloat = 0
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
