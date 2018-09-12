//
//  Board.swift
//  Abut
//
//  Created by Klemenz, Oliver on 08.08.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

protocol BoardDelegate: class {
    func didCollideBall(value: Int, multiplier: Int)
    func didUpdateColor(color: UIColor)
    func didUpdateMultiplier(multiplier: Int)
}

class Board : SKNode {

    let RestBias: CGFloat = 25.0
    
    enum GameStatus {
        case Init
        case Resting
        case Rolling
        case Aiming
        case Shooting
    }
    
    weak var delegate: BoardDelegate?
    
    let dice = Dice()
    let line = Line()
    let whiteBall = Ball.White
    let startSpot = StartSpot()
    let endSpot = EndSpot()

    var status: GameStatus = .Resting
    var highestColorValue = 1
    var highestColorCollisionContact = 0
    var multiplier = 1
    
    override init() {
        super.init()
       
        let w = UIScreen.main.bounds.width
        let w2 = w / 2.0
        let h = UIScreen.main.bounds.height - BAR_HEIGHT
        let h2 = h / 2.0
        
        let physicsPath = UIBezierPath(roundedRect: CGRect(x: -w2, y: -h2, width: w, height: h), cornerRadius: CORNER_RADIUS)
        physicsBody = SKPhysicsBody(edgeLoopFrom: physicsPath.cgPath)
        physicsBody?.isDynamic = false
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.collisionBitMask = CollisionCategoryDefault
        
        position = CGPoint(x: 0, y: -BAR_HEIGHT / 2)
        
        addChild(dice)
        addChild(line)
        addChild(endSpot)
        whiteBall.addChild(startSpot)
        addChild(whiteBall)

        line.isHidden = true
        startSpot.isHidden = true
        endSpot.isHidden = true
        
        status = .Init
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func start() {
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
    
    func rollStart() {
        let startBall = children.first { (node) -> Bool in
            if let ball = node as? Ball {
                return ball.value == 1
            }
            return false
        }
        // TODO: Roll other colored balls?
        if startBall == nil {
            rollBall(Ball())
        }
    }
    
    func roll() {
        rollStart()
        // TODO: Roll other colored balls?
        rollBall(Ball())
        updateColor()
    }
    
    func rollBall(_ ball: Ball) {
        addChild(ball)
        ball.roll()
        setStatusRolling()
        highestColorCollisionContact = 0
    }
    
    func setStatusResting() {
        if status != .Resting {
            status = .Resting
        }
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
        var highestColorValue = 1
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
        if contact.contactPoint.y + ball.radius > h2 - BAR_HEIGHT + CORNER_RADIUS {
            ball.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: -f))
        }
        // Bottom
        if contact.contactPoint.y - ball.radius < -h2 {
            ball.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: f))
        }
    }
    
    func collisionDetected(ballA: Ball, ballB: Ball) {
        if ballA.value == Ball.Black.value {
            // TODO: Black ball => add a black non-movebale square + smoke
        } else {
            if ballA.value == highestColorValue {
                highestColorCollisionContact += 1
                dice.countUp()
            }
            ballA.increase()
            ballB.removeFromParent()
            addChild(CollisionEffect(context: self.parent!, ballA: ballA, ballB: ballB))
            updateCollide(value: ballA.value)
            updateColor()
            updateMultiplier()
        }
    }

    func updateCollide(value: Int) {
        delegate?.didCollideBall(value: value, multiplier: multiplier)
    }
    
    func updateColor() {
        highestColorValue = determineHighestColorValue()
        delegate?.didUpdateColor(color: Ball.colorForValue(value: highestColorValue))
    }
    
    func updateMultiplier() {
        multiplier += 1
        delegate?.didUpdateMultiplier(multiplier: multiplier)
    }
    
    func resetMultiplier() {
        multiplier = 1
        delegate?.didUpdateMultiplier(multiplier: multiplier)
    }
    
    func pointTouched(position: CGPoint, began: Bool = false) {
        let h = UIScreen.main.bounds.height
        let h2 = h / 2.0
        if let startPoint = line.startPoint {
            if began && line.endPoint != nil && startPoint.distanceTo(position) <= whiteBall.radius * 3 {
                shoot()
            } else if (position.y < h2 - BAR_HEIGHT + CORNER_RADIUS) {
                line.endPoint = position
                endSpot.position = position
            }
        }
    }
    
    func update() {
        assertBallsInBoard()
        line.startPoint = whiteBall.position
        let rollingBall = children.first { (node) -> Bool in
            if let ball = node as? Ball {
                return ball.physicsBody!.velocity.length() >= RestBias
            }
            return false
        }
        if rollingBall == nil {
            if status == .Rolling {
                setStatusResting()
            } else if status == .Resting {
                setStatusAiming()
            } else if status == .Shooting {
                updateGameState()
                setStatusRolling()
            }
        }
    }
    
    func updateGameState() {
        if highestColorCollisionContact == 0 {
            resetMultiplier()
            if dice.value > 1 {
                dice.decrease()
                roll()
            } else {
                let ball = children.first { (node) -> Bool in
                    if let ball = node as? Ball {
                        return ball.value == highestColorValue
                    }
                    return false
                    } as? Ball
                if let ball = ball {
                    ball.removeFromParent()
                    addChild(ExplosionEffect(context: self.parent!, ball: ball))
                }
                run(SKAction.sequence([
                    SKAction.wait(forDuration: 0.5),
                    SKAction.run {
                        self.dice.countUp()
                        self.rollBall(Ball.Black)
                        self.roll()
                    }
                ]))
            }
        } else {
            roll()
        }
    }
    
    func assertBallsInBoard() {
        let w = UIScreen.main.bounds.width
        let w2 = w / 2.0
        let h = UIScreen.main.bounds.height
        let h2 = h / 2.0
        children.forEach { (node) in
            if let ball = node as? Ball {
                if ball.position.x < -w2 || ball.position.x > w2 ||
                    ball.position.y < -h2 || ball.position.y > h2 {
                    ball.roll()
                }
            }
        }
    }
    
    func save() -> [String:Any] {
        var data: [String:Any] = [:]
        var balls: [[String:Any]] = []
        var blocks: [[String:Any]] = []
        children.forEach { (node) in
            if let ball = node as? Ball {
                balls.append(ball.save())
            }
            if let block = node as? Block {
                blocks.append(block.save())
            }
        }
        data["balls"] = balls
        data["blocks"] = blocks
        data["dice"] = dice.value
        data["multi"] = multiplier
        return data
    }
    
    func load(data: [String:Any]) {
        children.forEach { (node) in
            if let ball = node as? Ball {
                if ball.value != whiteBall.value {
                    ball.removeFromParent()
                }
            }
            if let block = node as? Block {
                block.removeFromParent()
            }
        }
        let balls = data["balls"] as! [[String: Any]]
        for ballData in balls {
            let ball = Ball.load(data: ballData)
            if ball.value == whiteBall.value {
                whiteBall.position = ball.position
            } else {
                addChild(ball)
            }
        }
        let blocks = data["blocks"] as! [[String: Any]]
        for blockData in blocks {
            let block = Block.load(data: blockData)
            addChild(block)
        }
        dice.value = data["dice"] as! Int
        dice.place()
        multiplier = data["multi"] as! Int
        rollStart()
        setStatusAiming()
    }
}
