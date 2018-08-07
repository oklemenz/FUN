//
//  GameScene.swift
//  Abut
//
//  Created by Klemenz, Oliver on 17.07.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import SpriteKit
import GameplayKit
import AudioToolbox

let BALL_RADIUS: CGFloat = 16.0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let RestBias: CGFloat = 25.0
    
    enum GameStatus {
        case Resting
        case Rolling
        case Aiming
        case Shooting
    }
    
    let background = Background()
    let border = Border()
    let dice = Dice()
    let line = Line()
    let whiteBall = Ball.White
    let startSpot = StartSpot()
    let endSpot = EndSpot()
    
    var status: GameStatus = .Resting
    var highestColorValue = 0
    var highestColorCollisionContact = 0
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.speed = 0.9
        
        background.size.width = size.width
        background.size.height = size.height
        
        addChild(background)
        addChild(border)
        addChild(dice)
        addChild(line)
        addChild(whiteBall)

        whiteBall.roll()
        roll()
    }
    
    func shake(duration: Float) {
        let amplitudeX:Float = 10;
        let amplitudeY:Float = 6;
        let numberOfShakes = duration / 0.04;
        var actionsArray:[SKAction] = [];
        for _ in 1...Int(numberOfShakes) {
            let moveX = Float(arc4random_uniform(UInt32(amplitudeX))) - amplitudeX / 2;
            let moveY = Float(arc4random_uniform(UInt32(amplitudeY))) - amplitudeY / 2;
            let shakeAction = SKAction.moveBy(x: CGFloat(moveX), y: CGFloat(moveY), duration: 0.02);
            shakeAction.timingMode = SKActionTimingMode.easeOut;
            actionsArray.append(shakeAction);
            actionsArray.append(shakeAction.reversed());
        }
        let actionSeq = SKAction.sequence(actionsArray);
        run(actionSeq);
    }
    
    func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    func showGameOver() {
        let alertController = UIAlertController(title: "Game Over!", message: "You lost the game.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertController.addAction(action)
        UIApplication.shared.delegate?.window??.rootViewController?.present(alertController, animated: true, completion: nil)
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
            line.startPoint = nil
            startSpot.removeFromParent()
            endSpot.removeFromParent()
            status = .Rolling
        }
    }
    
    func setStatusAiming() {
        if status != .Aiming {
            line.startPoint = whiteBall.position
            line.isHidden = false
            whiteBall.addChild(startSpot)
            pointTouched(position: line.startPoint! - line.startPoint!.normalized() * 100)
            addChild(endSpot)
            status = .Aiming
        }
    }
    
    func setStatusShooting() {
        if status != .Shooting {
            highestColorCollisionContact = 0
            line.isHidden = true
            startSpot.removeFromParent()
            endSpot.removeFromParent()
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
        for i in 1...maxValue {
            if valueMap[i] ?? 0 > 1 {
                highestColorValue = i
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
        let w = UIScreen.main.bounds.width;
        let w2 = w / 2.0
        let h = UIScreen.main.bounds.height;
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
            addChild(ContactEffect(context: self, ballA: ballA, ballB: ballB))
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
    
    func didBegin(_ contact: SKPhysicsContact) {
        detectCollision(contact)
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        detectCollision(contact)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if status == .Aiming {
            if let touch = touches.first {
                pointTouched(position: touch.location(in: self), began: true)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if status == .Aiming {
            if let touch = touches.first {
                pointTouched(position: touch.location(in: self))
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if status == .Aiming {
            if let touch = touches.first {
                pointTouched(position: touch.location(in: self))
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if status == .Aiming {
        }
    }
   
    override func update(_ currentTime: TimeInterval) {
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
