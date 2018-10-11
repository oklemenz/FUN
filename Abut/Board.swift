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
    func didCollideBall(contactPoint: CGPoint, value: Int, multiplier: Int)
    func didUpdateColor(color: UIColor)
    func didUpdateMultiplier(multiplier: Int, roundMultiplier: Int)
    func didResetMultiplier()
}

var blockSound = SKAction.playSoundFileNamed("sounds/block.caf", waitForCompletion: false)
var bounceSound = SKAction.playSoundFileNamed("sounds/bounce.caf", waitForCompletion: false)
var contactSound = SKAction.playSoundFileNamed("sounds/contact.caf", waitForCompletion: false)
var explosionSound = SKAction.playSoundFileNamed("sounds/explosion.caf", waitForCompletion: false)
var highscoreSound = SKAction.playSoundFileNamed("sounds/highscore.caf", waitForCompletion: false)
var laserSound = SKAction.playSoundFileNamed("sounds/laser.caf", waitForCompletion: false)
var scoreSound = SKAction.playSoundFileNamed("sounds/score.caf", waitForCompletion: false)
var shootSound = SKAction.playSoundFileNamed("sounds/shoot.caf", waitForCompletion: false)
var wooshSound = SKAction.playSoundFileNamed("sounds/woosh.caf", waitForCompletion: false)

class Board : SKNode {

    let RestBias: CGFloat = 10.0
    
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
    var collisionContact = 0
    var highestColorValue = 1
    var highestColorCollisionContact = 0
    var multiplier = 0
    var roundMultiplier = 0
    
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
        run(shootSound)
        run(wooshSound)
        setStatusShooting()
    }
    
    func rollStart() {
        let startBall = children.first { (node) -> Bool in
            if let ball = node as? Ball {
                return ball.value == 1
            }
            return false
        }
        if startBall == nil {
            rollBall(Ball())
        }
    }
    
    func roll() {
        rollStart()
        rollBall(Ball())
        updateColor()
    }
    
    func rollBall(_ ball: Ball) {
        addChild(ball)
        ball.roll()
        setStatusRolling()
        collisionContact = 0
        highestColorCollisionContact = 0
        run(wooshSound)
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
            roundMultiplier = 0
            status = .Aiming
        }
    }
    
    func setStatusShooting() {
        if status != .Shooting {
            collisionContact = 0
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
                    run(contactSound)
                    if ballA.value == ballB.value {
                        collisionDetected(contactPoint: contact.contactPoint, ballA: ballA, ballB: ballB)
                    }
                }
            } else if contact.bodyA.collisionBitMask == CollisionCategoryDefault ||
                contact.bodyB.collisionBitMask == CollisionCategoryDefault {
                run(bounceSound)
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
        if contact.contactPoint.x + ball.radius >= w2 {
            ball.physicsBody?.applyImpulse(CGVector(dx: -f, dy: 0.0))
        }
        // Left
        if contact.contactPoint.x - ball.radius <= -w2 {
            ball.physicsBody?.applyImpulse(CGVector(dx: f, dy: 0.0))
        }
        // Top
        if contact.contactPoint.y + ball.radius >= h2 - BAR_HEIGHT {
            ball.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: -f))
        }
        // Bottom
        if contact.contactPoint.y - ball.radius <= -h2 {
            ball.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: f))
        }
    }
    
    func collisionDetected(contactPoint: CGPoint, ballA: Ball, ballB: Ball) {
        if ballA.value == Ball.Black.value {
            ballA.removeFromParent()
            ballB.removeFromParent()
            let block = Block()
            block.position = contactPoint
            addChild(block)
            addChild(BlockedEffect(context: self.parent!, contactPoint: contactPoint))
            run(blockSound)
            updateColor()
            resetMultiplier()
        } else {
            handleMatch(contactPoint: contactPoint, ballA: ballA, ballB: ballB)
        }
    }
    
    func handleMatch(contactPoint: CGPoint, ballA: Ball, ballB: Ball) {
        collisionContact += 1
        if ballA.value == highestColorValue {
            highestColorCollisionContact += 1
            dice.countUp()
        }
        ballA.increase()
        ballB.removeFromParent()
        addChild(CollisionEffect(context: self.parent!, contactPoint: contactPoint, ballA: ballA, ballB: ballB))
        run(laserSound)
        updateCollide(contactPoint: contactPoint, value: ballA.value)
        updateColor()
        updateMultiplier()
    }
            
    func explodeBlock() {
        let block = children.first { (child) -> Bool in
            if let _ = child as? Block {
                return true
            }
            return false
        }
        if let block = block as? Block {
            block.removeFromParent()
            addChild(ExplosionEffect(context: self.parent!, block: block))
            run(explosionSound)
        }
    }

    func updateCollide(contactPoint: CGPoint, value: Int) {
        delegate?.didCollideBall(contactPoint: contactPoint, value: value, multiplier: multiplier)
    }
    
    func updateColor() {
        highestColorValue = determineHighestColorValue()
        delegate?.didUpdateColor(color: Ball.colorForValue(highestColorValue))
    }
    
    func updateMultiplier() {
        multiplier += 1
        roundMultiplier += 1
        delegate?.didUpdateMultiplier(multiplier: multiplier, roundMultiplier: roundMultiplier)
    }
    
    func resetMultiplier() {
        multiplier = 0
        roundMultiplier = 0
        delegate?.didResetMultiplier()
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
        if collisionContact == 0 {
            resetMultiplier()
        }
        if highestColorCollisionContact == 0 {
            if dice.value > 1 {
                dice.decrease()
                roll()
            } else {
                diceZero()
            }
        } else {
            roll()
        }
    }
    
    func diceZero() {
        let ball = children.first { (node) -> Bool in
            if let ball = node as? Ball {
                return ball.value == highestColorValue
            }
            return false
            } as? Ball
        if let ball = ball {
            ball.removeFromParent()
            addChild(ExplosionEffect(context: self.parent!, ball: ball))
            run(explosionSound)
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
        data["multiplier"] = multiplier
        return data
    }
    
    func load(data: [String:Any]) {
        reset()
        let balls = data["balls"] as! [[String: Any]]
        for ballData in balls {
            let ball = Ball.load(data: ballData)
            if ball.value == whiteBall.value {
                if whiteBall.parent == nil {
                    addChild(whiteBall)
                }
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
        multiplier = data["multiplier"] as! Int
        roundMultiplier = 0
        rollStart()
        setStatusAiming()
    }
    
    func reset() {
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
    }
    
    func new() {
        reset()
        dice.value = 6
        dice.place()
        multiplier = 0
        roundMultiplier = 0
        rollStart()
        setStatusAiming()
    }
}
