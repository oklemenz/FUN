//
//  Board.swift
//  Abut
//
//  Created by Klemenz, Oliver on 08.08.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit
import AudioToolbox

protocol BoardDelegate: class {
    func didCollideBall(contactPoint: CGPoint, value: Int, multiplier: Int)
    func didUpdateColor(color: UIColor)
    func didUpdateMultiplier(multiplier: Int, roundMultiplier: Int)
    func didResetMultiplier()
    func didUnlockNewColor(color: Int)
}

let blockSound = SKAction.playSoundFileNamed("sounds/block.caf", waitForCompletion: false)
let bounceSound = SKAction.playSoundFileNamed("sounds/bounce.caf", waitForCompletion: false)
let buttonSound = SKAction.playSoundFileNamed("sounds/button.caf", waitForCompletion: false)
let contactSound = SKAction.playSoundFileNamed("sounds/contact.caf", waitForCompletion: false)
let explosionSound = SKAction.playSoundFileNamed("sounds/explosion.caf", waitForCompletion: false)
let highscoreSound = SKAction.playSoundFileNamed("sounds/highscore.caf", waitForCompletion: false)
let laserSound = SKAction.playSoundFileNamed("sounds/laser.caf", waitForCompletion: false)
let scoreSound = SKAction.playSoundFileNamed("sounds/score.caf", waitForCompletion: false)
let newColorSound = SKAction.playSoundFileNamed("sounds/newcolor.caf", waitForCompletion: false)
let shootSound = SKAction.playSoundFileNamed("sounds/shoot.caf", waitForCompletion: false)
let wooshSound = SKAction.playSoundFileNamed("sounds/woosh.caf", waitForCompletion: false)

let BOUNDARY: CGFloat = 100
let BOUNDARY_INSET: CGFloat = 1

class Board : SKNode {

    let RestBias: CGFloat = 10.0
    
    enum GameStatus {
        case Init
        case Resting
        case Rolling
        case Aiming
        case Shooting
    }
    
    weak var boardDelegate: BoardDelegate?
    
    let dice = Dice()
    let line = Line()
    let whiteBall = Ball.White
    let startSpot = StartSpot()
    let endSpot = EndSpot()
    let hand = Hand()

    var showIntro: Bool = true
    var status: GameStatus = .Resting
    var collisionContact = 0
    var highestColorValue = 1
    var leadingColorValue = 1
    var leadingColorCollisionContact = 0
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
        
        addBoundary()
        addChild(dice)
        addChild(line)
        addChild(endSpot)
        whiteBall.addChild(startSpot)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setup() {
        line.isHidden = true
        startSpot.isHidden = true
        endSpot.isHidden = true
        status = .Init
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
        if Settings.instance.sound {
            run(shootSound)
            run(wooshSound)
        }
        setStatusShooting()
        let peek = SystemSoundID(1519)
        AudioServicesPlaySystemSound(peek)
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
        updateLeadingColor()
        updateHighestColor()
    }
    
    func rollBall(_ ball: Ball) {
        addChild(ball)
        ball.roll()
        setStatusRolling()
        collisionContact = 0
        leadingColorCollisionContact = 0
        if Settings.instance.sound {
            run(wooshSound)
        }
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
            showIntroHandStart()
        }
    }
    
    func setStatusShooting() {
        if status != .Shooting {
            collisionContact = 0
            leadingColorCollisionContact = 0
            line.isHidden = true
            startSpot.isHidden = true
            endSpot.isHidden = true
            status = .Shooting
            showIntroHandEnd()
        }
    }
    
    func showIntroHandStart() {
        if showIntro && hand.status == .Start {
            addChild(hand)
            hand.start(endSpot.position)
            let ball = children.first { (child) -> Bool in
                if let ball = child as? Ball {
                    return ball.value > 0
                }
                return false
            }
            if let ball = ball as? Ball {
                let to = (ball.position - whiteBall.position).normalized() * 100
                hand.end(whiteBall.position + to)
                hand.status = .Set
            } else {
                hand.status = .End
            }
        }
    }
    
    func showIntroHandWait() {
        if showIntro && hand.status == .Move {
            hand.status = .Wait
        }
    }
    
    func showIntroHandPress() {
        if showIntro && hand.status == .Wait {
            hand.start(whiteBall.position)
            hand.status = .Press
        }
    }
    
    func showIntroHandEnd() {
        if showIntro && hand.status != .End {
            hand.status = .End
            showIntro = false
        }
    }
    
    func determineHighestColorValue() -> Int {
        var highestColorValue = 1
        for child in children {
            if let ball = child as? Ball {
                if ball.value > highestColorValue {
                    highestColorValue = ball.value
                }
            }
        }
        return highestColorValue
    }
    
    func determineLeadingColorValue() -> Int {
        var leadingColorValue = 1
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
                    leadingColorValue = i
                }
            }
        }
        return leadingColorValue
    }
    
    func detectCollision(_ contact: SKPhysicsContact) {
        if status == .Shooting {
            if contact.bodyA.collisionBitMask == CollisionCategoryBall && contact.bodyA != whiteBall &&
                contact.bodyB.collisionBitMask == CollisionCategoryBall && contact.bodyB != whiteBall {
                if let ballA = contact.bodyA.node as? Ball,
                    let ballB = contact.bodyB.node as? Ball {
                    if Settings.instance.sound {
                        run(contactSound)
                    }
                    if ballA.value == ballB.value {
                        collisionDetected(contactPoint: contact.contactPoint, ballA: ballA, ballB: ballB)
                    }
                }
            } else if contact.bodyA.collisionBitMask == CollisionCategoryDefault ||
                contact.bodyB.collisionBitMask == CollisionCategoryDefault {
                if Settings.instance.sound {
                    run(bounceSound)
                }
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
        if ballA.value == Ball.Black.value && ballB.value == Ball.Black.value {
            let point = ballA.position.middleTo(ballB.position)
            let block = Block()
            block.position = point
            addChild(block)
            ballA.removeFromParent()
            ballB.removeFromParent()
            addChild(BlockedEffect(context: self, point: point))
            if Settings.instance.sound {
                run(blockSound)
            }
            updateLeadingColor()
            updateHighestColor()
            resetMultiplier()
        } else {
            handleMatch(contactPoint: contactPoint, ballA: ballA, ballB: ballB)
        }
    }
    
    func handleMatch(contactPoint: CGPoint, ballA: Ball, ballB: Ball) {
        collisionContact += 1
        if ballA.value == leadingColorValue {
            leadingColorCollisionContact += 1
            dice.countUp()
        }
        ballA.increase()
        ballB.removeFromParent()
        addChild(CollisionEffect(context: self, ballA: ballA, ballB: ballB))
        if Settings.instance.sound {
            run(laserSound)
        }
        updateCollide(contactPoint: contactPoint, value: ballB.value)
        updateLeadingColor()
        updateHighestColor()
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
            addChild(ExplosionEffect(context: self, block: block))
            if Settings.instance.sound {
                run(explosionSound)
            }
        }
    }

    func updateCollide(contactPoint: CGPoint, value: Int) {
        boardDelegate?.didCollideBall(contactPoint: contactPoint, value: value, multiplier: multiplier)
    }
    
    func updateLeadingColor() {
        leadingColorValue = determineLeadingColorValue()
        boardDelegate?.didUpdateColor(color: Ball.colorForValue(leadingColorValue))
    }
    
    func updateHighestColor(_ suppress: Bool = false) {
        let newHighestColorValue = determineHighestColorValue()
        if newHighestColorValue > highestColorValue && !suppress {
            boardDelegate?.didUnlockNewColor(color: newHighestColorValue)
            explodeBlock()
        }
        highestColorValue = newHighestColorValue
    }
    
    func updateMultiplier() {
        multiplier += 1
        roundMultiplier += 1
        boardDelegate?.didUpdateMultiplier(multiplier: multiplier, roundMultiplier: roundMultiplier)
    }
    
    func resetMultiplier() {
        multiplier = 0
        roundMultiplier = 0
        boardDelegate?.didResetMultiplier()
    }
    
    func pointTouched(position: CGPoint, began: Bool = false) {
        let h = UIScreen.main.bounds.height
        let h2 = h / 2.0
        if let startPoint = line.startPoint {
            let screenPosition = convert(position, to: parent!)
            if began && line.endPoint != nil && startPoint.distanceTo(position) <= whiteBall.radius * 3 {
                shoot()
            } else if (screenPosition.y < h2 - BAR_HEIGHT) {
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
                if let physicsBody = ball.physicsBody {
                    return physicsBody.velocity.length() >= RestBias
                }
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
        if leadingColorCollisionContact == 0 {
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
                return ball.value == leadingColorValue
            }
            return false
            } as? Ball
        if let ball = ball {
            ball.removeFromParent()
            addChild(ExplosionEffect(context: self, ball: ball))
            if Settings.instance.sound {
                run(explosionSound)
            }
            resetMultiplier()
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
    
    func addBoundary() {
        topBoundary()
        bottomBoundary()
        leftBoundary()
        rightBoundary()
    }
    
    func topBoundary() {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let h2 = h / 2.0
        let size = CGSize(width: w + 2 * BOUNDARY, height: BOUNDARY)
        let top = SKShapeNode(rectOf: size)
        top.zPosition = 0
        top.fillColor = .clear
        top.strokeColor = .clear
        top.physicsBody = SKPhysicsBody(rectangleOf: size)
        top.physicsBody?.isDynamic = false
        top.physicsBody?.usesPreciseCollisionDetection = true
        top.position = CGPoint(x: 0, y: h2 + BOUNDARY/2 + BOUNDARY_INSET + position.y)
        addChild(top)
    }
    
    func bottomBoundary() {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let h2 = h / 2.0
        let size = CGSize(width: w + 2 * BOUNDARY, height: BOUNDARY)
        let bottom = SKShapeNode(rectOf: size)
        bottom.zPosition = 0
        bottom.fillColor = .clear
        bottom.strokeColor = .clear
        bottom.physicsBody = SKPhysicsBody(rectangleOf: size)
        bottom.physicsBody?.isDynamic = false
        bottom.physicsBody?.usesPreciseCollisionDetection = true
        bottom.position = CGPoint(x: 0, y: -h2 - BOUNDARY/2 - BOUNDARY_INSET - position.y)
        addChild(bottom)
    }
    
    func leftBoundary() {
        let w = UIScreen.main.bounds.width
        let w2 = w / 2.0
        let h = UIScreen.main.bounds.height
        let size = CGSize(width: BOUNDARY, height: h + 2 * BOUNDARY)
        let left = SKShapeNode(rectOf: size)
        left.zPosition = 0
        left.fillColor = .clear
        left.strokeColor = .clear
        left.physicsBody = SKPhysicsBody(rectangleOf: size)
        left.physicsBody?.isDynamic = false
        left.physicsBody?.usesPreciseCollisionDetection = true
        left.position = CGPoint(x: -w2 - BOUNDARY/2 - BOUNDARY_INSET, y: 0)
        addChild(left)
    }
    
    func rightBoundary() {
        let w = UIScreen.main.bounds.width
        let w2 = w / 2.0
        let h = UIScreen.main.bounds.height
        let size = CGSize(width: BOUNDARY, height: h + 2 * BOUNDARY)
        let right = SKShapeNode(rectOf: size)
        right.zPosition = 0
        right.fillColor = .clear
        right.strokeColor = .clear
        right.physicsBody = SKPhysicsBody(rectangleOf: size)
        right.physicsBody?.isDynamic = false
        right.physicsBody?.usesPreciseCollisionDetection = true
        right.position = CGPoint(x: w2 + BOUNDARY/2 + BOUNDARY_INSET, y: 0)
        addChild(right)
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
        showIntro = false
        dice.value = data["dice"] as! Int
        dice.place()
        multiplier = data["multiplier"] as! Int
        roundMultiplier = 0
        updateLeadingColor()
        updateHighestColor(true)
        rollStart()
        setStatusAiming()
    }
    
    func reset() {
        dice.value = 6
        dice.place()
        status = .Resting
        collisionContact = 0
        highestColorValue = 1
        leadingColorValue = 1
        leadingColorCollisionContact = 0
        multiplier = 0
        roundMultiplier = 0
        children.forEach { (node) in
            if let ball = node as? Ball {
                ball.removeFromParent()
            }
            if let block = node as? Block {
                block.removeFromParent()
            }
        }
        setup()
    }
    
    func new() {
        reset()
        start()
    }
}
