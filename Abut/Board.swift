//
//  Board.swift
//  Abut
//
//  Created by Klemenz, Oliver on 08.08.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

class Board : SKNode {

    let RestBias: CGFloat = 25.0
    
    enum GameStatus {
        case Init
        case Resting
        case Rolling
        case Aiming
        case Shooting
    }
    
    var background: SKSpriteNode!
    var border: Border? {
        didSet {
            updateBorder()
        }
    }
    
    let dice = Dice()
    let line = Line()
    let whiteBall = Ball.White
    let startSpot = StartSpot()
    let endSpot = EndSpot()

    var status: GameStatus = .Resting
    var highestColorValue = 0
    var highestColorCollisionContact = 0
    
    override init() {
        super.init()
       
        let w:CGFloat = UIScreen.main.bounds.width
        let w2 = w / 2.0
        let h:CGFloat = UIScreen.main.bounds.height - BAR_HEIGHT
        let h2 = h / 2.0
        
        let physicsPath = UIBezierPath(roundedRect: CGRect(x: -w2, y: -h2, width: w, height: h), cornerRadius: CORNER_RADIUS)
        physicsBody = SKPhysicsBody(edgeLoopFrom: physicsPath.cgPath)
        physicsBody?.isDynamic = false
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.collisionBitMask = CollisionCategoryDefault
        
        position = CGPoint(x: 0, y: -BAR_HEIGHT / 2)
        
        // TODO: Use rounded rect with texture
        let texture = SKTexture(size: UIScreen.main.bounds.width, color1: CIColor(rgba: "#116316"), color2: CIColor(rgba: "#0d3303"))
        background = SKSpriteNode(texture: texture, color: UIColor.white, size: texture.size())
        background.zPosition = 0.1
        background.size.width = w
        background.size.height = h
        addChild(background)
        addChild(dice)
        addChild(line)
        addChild(endSpot)
        whiteBall.addChild(startSpot)
        line.isHidden = true
        startSpot.isHidden = true
        endSpot.isHidden = true
        
        status = .Init
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func start() {
        addChild(whiteBall)
        whiteBall.roll()
        roll()
        status = .Rolling
    }
    
    func shoot() {
        let vector = CGVector(
            dx: line.endPoint!.x - line.startPoint!.x,
            dy: line.endPoint!.y - line.startPoint!.y
        )
        whiteBall.shoot(vector: vector)
        setStatusShooting()
    }
    
    func decreaseDice() {
        if dice.value > 1 {
            dice.decrease()
        } else {
            // TODO: Explode one of the hightest colored balls
            rollBall(Ball.Black)
            dice.countUp()
        }
    }
    
    func increaseDice() {
        dice.increase()
    }
    
    func roll() {
        let startBall = children.first { (node) -> Bool in
            if let ball = node as? Ball {
                return ball.value == 1
            }
            return false
        }
        if startBall == nil {
            rollBall(Ball())
        }
        rollBall(Ball())
        updateBorder()
    }
    
    func rollBall(_ ball: Ball) {
        highestColorCollisionContact = 0
        // TODO: Roll other colored balls?
        addChild(ball)
        ball.roll()
        setStatusRolling()
    }
    
    func setStatusRolling() {
        if status != .Rolling {
            line.isHidden = true
            startSpot.isHidden = true
            endSpot.isHidden = true
            status = .Rolling
        }
    }
    
    func setStatusAiming() {
        if status != .Aiming {
            line.startPoint = whiteBall.position
            line.isHidden = false
            startSpot.isHidden = false
            endSpot.isHidden = false
            pointTouched(position: line.startPoint! - line.startPoint!.normalized() * 100)
            status = .Aiming
        }
    }
    
    func setStatusShooting() {
        if status != .Shooting {
            highestColorCollisionContact = 0
            line.isHidden = true
            startSpot.isHidden = true
            endSpot.isHidden = true
            status = .Shooting
        }
    }
    
    func determineHighestColorValue() -> Int {
        highestColorValue = 1
        var valueMap: [Int: Int] = [:]
        for child in children {
            if let ball = child as? Ball {
                if let value = valueMap[ball.value] {
                    valueMap[ball.value] = value + 1
                } else {
                    valueMap[ball.value] = 1
                }
            }
        }
        let maxValue = valueMap.keys.max() ?? 1
        if maxValue > 0 {
            for i in 1...maxValue {
                if valueMap[i] ?? 0 > 1 {
                    highestColorValue = i
                }
            }
        }
        return highestColorValue
    }
    
    func detectCollision(_ contact: SKPhysicsContact) {
        if status == .Shooting {
            if contact.bodyA.collisionBitMask == CollisionCategoryBall && contact.bodyA != whiteBall &&
                contact.bodyB.collisionBitMask == CollisionCategoryBall && contact.bodyB != whiteBall {
                if let ballA = contact.bodyA.node as? Ball,
                    let ballB = contact.bodyB.node as? Ball {
                    if ballA.value == ballB.value {
                        collisionDetected(ballA: ballA, ballB: ballB)
                    }
                }
            } else if contact.bodyA.collisionBitMask == CollisionCategoryDefault ||
                contact.bodyB.collisionBitMask == CollisionCategoryDefault {
                if contact.bodyA.collisionBitMask == CollisionCategoryBall {
                    if let ball = contact.bodyA.node as? Ball {
                        pushBall(ball: ball, contact: contact)
                    }
                }
                if contact.bodyB.collisionBitMask == CollisionCategoryBall {
                    if let ball = contact.bodyB.node as? Ball {
                        pushBall(ball: ball, contact: contact)
                    }
                }
            }
        }
    }
    
    func pushBall(ball: Ball, contact: SKPhysicsContact) {
        let w = UIScreen.main.bounds.width
        let w2 = w / 2.0
        let h = UIScreen.main.bounds.height
        let h2 = h / 2.0
        let f = 0.5
        // Right
        if contact.contactPoint.x + ball.radius > w2 {
            ball.physicsBody?.applyImpulse(CGVector(dx: -f, dy: 0.0))
        }
        // Left
        if contact.contactPoint.x - ball.radius < -w2 {
            ball.physicsBody?.applyImpulse(CGVector(dx: f, dy: 0.0))
        }
        // Top
        if contact.contactPoint.y + ball.radius > h2 {
            ball.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: -f))
        }
        // Bottom
        if contact.contactPoint.y - ball.radius < -h2 {
            ball.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: f))
        }
    }
    
    func collisionDetected(ballA: Ball, ballB: Ball) {
        if ballA.value == Ball.Black.value {
            // TODO: Black ball => add a black non-movebale square
        } else {
            if ballA.value == highestColorValue {
                highestColorCollisionContact += 1
                dice.countUp()
            }
            ballA.increase()
            ballB.removeFromParent()
            addChild(CollisionEffect(context: self.parent!, ballA: ballA, ballB: ballB))
            updateBorder()
        }
    }
    
    func updateBorder() {
        if let border = border {
            border.color = Ball.colorForValue(value: determineHighestColorValue())
        }
    }
    
    func pointTouched(position: CGPoint, began: Bool = false) {
        if let startPoint = line.startPoint {
            if began && line.endPoint != nil && startPoint.distanceTo(position) <= whiteBall.radius * 3 {
                shoot()
            } else {
                line.endPoint = position
                endSpot.position = position
            }
        }
    }
    
    func update() {
        line.startPoint = whiteBall.position
        let child = children.first { (node) -> Bool in
            if let ball = node as? Ball {
                return ball.physicsBody!.velocity.length() >= RestBias
            }
            return false
        }
        if child === nil {
            if status == .Rolling {
                status = .Resting
            } else if status == .Resting {
                setStatusAiming()
            } else if status == .Shooting {
                if highestColorCollisionContact == 0 {
                    decreaseDice()
                }
                roll()
            }
        }
    }
}
