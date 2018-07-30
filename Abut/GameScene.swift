//
//  GameScene.swift
//  Abut
//
//  Created by Klemenz, Oliver on 17.07.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import SpriteKit
import GameplayKit

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
    let whiteBall = Ball.White()
    let startSpot = StartSpot()
    let endSpot = EndSpot()
    
    var status: GameStatus = .Resting
    var shootContact = 0
    
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
    
    func shoot() {
        let vector = CGVector(
            dx: line.endPoint!.x - line.startPoint!.x,
            dy: line.endPoint!.y - line.startPoint!.y
        )
        whiteBall.shoot(vector: vector)
        setStatusShooting()
    }
    
    func decreaseDice() {
        dice.decrease()
        if dice.value <= 0 {
            let alertController = UIAlertController(title: "Game Over!", message: "You lost the game.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            }
            alertController.addAction(action)
            UIApplication.shared.delegate?.window??.rootViewController?.present(alertController, animated: true, completion: nil)
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
            rollBall()
        }
        rollBall()
    }
    
    func rollBall() {
        shootContact = 0
        let ball = Ball()
        addChild(ball)
        ball.roll()
        setStatusRolling()
    }
    
    func pointTouched(position: CGPoint, began: Bool = false) {
        if let startPoint = line.startPoint {
            if began && line.endPoint != nil && startPoint.distanceTo(position) <= 2.5 * whiteBall.radius {
                shoot()
            } else {
                line.endPoint = position
                endSpot.position = position
            }
        }
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
            whiteBall.addChild(startSpot)
            pointTouched(position: line.startPoint! - line.startPoint!.normalized() * 100)
            addChild(endSpot)
            status = .Aiming
        }
    }
    
    func setStatusShooting() {
        if status != .Shooting {
            shootContact = 0
            line.startPoint = nil
            startSpot.removeFromParent()
            endSpot.removeFromParent()
            status = .Shooting
        }
    }
    
    func shootContact(ballA: Ball, ballB: Ball) {
        ballA.increase()
        ballB.removeFromParent()
        shootContact += 1
        addChild(ContactEffect(context: self, ballA: ballA, ballB: ballB))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if status == .Shooting {
            if contact.bodyA.collisionBitMask == CollisionCategoryBall && contact.bodyA != whiteBall &&
                contact.bodyB.collisionBitMask == CollisionCategoryBall && contact.bodyB != whiteBall {
                if let ballA = contact.bodyA.node as? Ball,
                    let ballB = contact.bodyB.node as? Ball {
                    if ballA.value == ballB.value {
                        shootContact(ballA: ballA, ballB: ballB)
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            pointTouched(position: touch.location(in: self), began: true)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            pointTouched(position: touch.location(in: self))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            pointTouched(position: touch.location(in: self))
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
   
    override func update(_ currentTime: TimeInterval) {
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
                if shootContact > 0 {
                    increaseDice()
                } else {
                    decreaseDice()
                }
                roll()
            }
        }
    }
}
