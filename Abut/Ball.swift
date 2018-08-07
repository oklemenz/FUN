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
    
    let radius: CGFloat = BALL_RADIUS
    
    var color = SKColor.white
    var value = 0 {
        didSet {
            render()
        }
    }

    static var Black: Ball {
        return Ball(value: -1)
    }
    
    static var White: Ball {
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
        physicsBody?.restitution = 0.7
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
        path = CGPath(ellipseIn: CGRect(origin: CGPoint(x: -radius, y: -radius),
                                        size: CGSize(width: radius * 2, height: radius * 2)), transform: nil)
        strokeColor = SKColor.clear
        color = Ball.colorForValue(value: value)
        fillColor = color
        glowWidth = 1
    }
   
    static func colorForValue(value: Int) -> SKColor {
        var color: SKColor
        switch value {
            case -1:
                color = .black
            case 0:
                color = .white
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
            case 9:
                // TODO: Color?
                color = .black
            case 10:
                // TODO: Color?
                color = .black
            case 11:
                // TODO: Color?
                color = .black
            case 12:
                // TODO: Color?
                color = .black
            case 13:
                // TODO: Color?
                color = .black
            case 14:
                // TODO: Color?
                color = .black
            case 15:
                // TODO: Color?
                color = .black
            case 16:
                // TODO: Color?
                color = .black
            default:
                // TODO: Color?
                color = .clear
        }
        return color
    }
    
    func shoot(vector: CGVector) {
        physicsBody?.applyImpulse(vector)
    }
    
    func roll() {
        let w = UIScreen.main.bounds.width;
        let w2 = w / 2.0
        let h = UIScreen.main.bounds.height;
        let h2 = h / 2.0
        let side = randomInt(min: 1, max: 4)
        let fx = randomCGFloat(min: 5, max: 10)
        let fy = randomCGFloat(min: 5, max: 10)
        let distance: CGFloat = 20
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        var dx: CGFloat = 0
        var dy: CGFloat = 0
        switch (side) {
            case 1:
                x = randomCGFloat(min: -w2 + radius + distance, max: w2 - radius - distance)
                y = h2 - radius - distance
                dx = x < 0 ? 1 : -1
                dy = -1
            case 2:
                x = w2 - radius - distance
                y = randomCGFloat(min: -h2 + radius + distance, max: h2 - radius - distance)
                dx = -1
                dy = y < 0 ? 1 : -1
            case 3:
                x = randomCGFloat(min: -w2 + radius + distance, max: w2 - radius - distance)
                y = -h2 + radius + distance
                dx = x < 0 ? 1 : -1
                dy = 1
            case 4:
                x = -w2 + radius + distance
                y = randomCGFloat(min: -h2 + radius + distance, max: h2 - radius - distance)
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
