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
let CollisionCategoryBlock: UInt32 = 0x1 << 2

let BALL_BORDER: CGFloat = 5

class Ball : SKShapeNode {
    
    let radius: CGFloat = BALL_RADIUS
    var border: CGFloat = 0
    
    var color = SKColor.white
    var borderColor = UIColor.clear
    
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
        
        physicsBody = SKPhysicsBody(circleOfRadius: radius + 1)
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
        border = value <= 8 ? 0 : BALL_BORDER
        path = CGPath(ellipseIn: CGRect(origin: CGPoint(x: -radius - border / 2.0, y: -radius - border / 2.0),
                                        size: CGSize(width: radius * 2 - border, height: radius * 2 - border)),
                      transform: nil)
        color = Ball.colorForValue(value)
        borderColor = Ball.strokeColorForValue(value: value)

        fillColor = color
        strokeColor = borderColor
        lineWidth = border
        glowWidth = 1
    }
   
    static func strokeColorForValue(value: Int) -> SKColor {
        if value <= 8 {
            return .clear
        } else {
            return .white
        }
    }
    
    static func colorForValue(_ value: Int) -> SKColor {
        var color: SKColor
        if value == -1 {
            color = .black
        } else if value == 0 {
            color = .white
        } else {
            switch value % 8 {
                case 1:
                    color = COLOR_RED
                case 2:
                    color = COLOR_ORANGE
                case 3:
                    color = COLOR_YELLOW
                case 4:
                    color = COLOR_GREEN
                case 5:
                    color = COLOR_TEAL_BLUE
                case 6:
                    color = COLOR_BLUE
                case 7:
                    color = COLOR_PURPLE
                case 0:
                    color = COLOR_PINK                
                default:
                    color = .darkGray
            }
        }
        return color
    }
    
    static func colorNameForValue(_ value: Int) -> String {
        var color = ""
        switch value {
        case -1:
            color = "black"
        case 0:
            color = "white"
        case 1:
            color = "red"
        case 2:
            color = "orange"
        case 3:
            color = "yellow"
        case 4:
            color = "green"
        case 5:
            color = "turquois"
        case 6:
            color = "blue"
        case 7:
            color = "purple"
        case 8:
            color = "pink"
        case 9:
            color = "red white"
        case 10:
            color = "orange white"
        case 11:
            color = "yellow white"
        case 12:
            color = "green white"
        case 13:
            color = "turquois white"
        case 14:
            color = "blue white"
        case 15:
            color = "purple white"
        case 16:
            color = "pink white"
        default:
            color = ""
        }
        return color
    }
    
    func shoot(vector: CGVector) {
        physicsBody?.applyImpulse(vector)
    }
    
    func roll() {
        let w = UIScreen.main.bounds.width
        let w2 = w / 2.0
        let h = UIScreen.main.bounds.height - BAR_HEIGHT
        let h2 = h / 2.0
        let space: CGFloat = 10
        let side = randomInt(min: 1, max: 4)
        let fx = randomCGFloat(min: 5, max: 10)
        let fy = randomCGFloat(min: 5, max: 10)
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        var dx: CGFloat = 0
        var dy: CGFloat = 0
        switch (side) {
            case 1:
                // top
                x = randomCGFloat(min: -w2 + radius + space, max: w2 - radius - space)
                y = h2 - radius - space
                dx = x < 0 ? 1 : -1
                dy = -1
            case 2:
                // right
                x = w2 - radius - space
                y = randomCGFloat(min: -h2 + radius + space, max: h2 - radius - space)
                dx = -1
                dy = y < 0 ? 1 : -1
            case 3:
                // bottom
                x = randomCGFloat(min: -w2 + radius + space, max: w2 - radius - space)
                y = -h2 + radius + space
                dx = x < 0 ? 1 : -1
                dy = 1
            case 4:
                // left
                x = -w2 + radius + space
                y = randomCGFloat(min: -h2 + radius + space, max: h2 - radius - space)
                dx = 1
                dy = y < 0 ? 1 : -1
            default:
                x = 0
                y = 0
        }
        position = CGPoint(x: x, y: y)
        shoot(vector: CGVector(dx: dx * fx, dy: dy * fy))
    }
    
    func save() -> [String:Any] {
        var data: [String:Any] = [:]
        data["x"] = position.x
        data["y"] = position.y
        data["v"] = value
        return data
    }
    
    static func load(data: [String:Any]) -> Ball {
        let ball = Ball()
        ball.position = CGPoint(x: data["x"] as! CGFloat, y: data["y"] as! CGFloat)
        ball.value = data["v"] as! Int
        return ball
    }
}
