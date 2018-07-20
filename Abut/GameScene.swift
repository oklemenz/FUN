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
    
    enum GameStatus {
        case Rolling
        case Aiming
        case Shooting
    }
    
    let RestBias: CGFloat = 25.0
    
    let background = SKSpriteNode(texture: SKTexture(size: UIScreen.main.bounds.width, color1: CIColor(rgba: "#116316"), color2: CIColor(rgba: "#0d3303")))

    let whiteBall = Ball.White()
    let blackBall = Ball.Black()
    
    let line = Line()
    let startSpot = StartSpot()
    let endSpot = EndSpot()
    
    let dice = Dice()
    
    var status: GameStatus = .Rolling
    var shootContact = false
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.speed = 0.1
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.isDynamic = false
        physicsBody?.usesPreciseCollisionDetection = true
        
        background.zPosition = 0
        background.position = CGPoint(x: 0, y: 0)
        background.size.width = size.width
        background.size.height = size.height
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(background)
        addChild(dice)
        
        addChild(whiteBall)
        addChild(blackBall)
        addChild(line)
        
        whiteBall.rollIn()
        blackBall.rollIn()
    }
    
    func shoot() {
        let vector = CGVector(
            dx: line.endPoint!.x - line.startPoint!.x,
            dy: line.endPoint!.y - line.startPoint!.y
        )
        whiteBall.shoot(vector: vector * 5)
        setStatusShooting()
    }
    
    func rollBall() {
        shootContact = true
        let ball = Ball()
        addChild(ball)
        ball.rollIn()
        setStatusRolling()
    }
    
    func pointTouched(position: CGPoint, began: Bool = false) {
        if let startPoint = line.startPoint {
            if began && line.endPoint != nil && startPoint.distanceTo(position) <= whiteBall.radius {
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
            pointTouched(position: CGPoint(x: 0, y: 0))
            addChild(endSpot)
            status = .Aiming
        }
    }
    
    func setStatusShooting() {
        if status != .Shooting {
            shootContact = false
            line.startPoint = nil
            startSpot.removeFromParent()
            endSpot.removeFromParent()
            status = .Shooting
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if status == .Shooting {
            if contact.bodyA.collisionBitMask == CollisionCategoryBall && contact.bodyA != whiteBall &&
                contact.bodyB.collisionBitMask == CollisionCategoryBall && contact.bodyB != whiteBall {
                if let ballA = contact.bodyA.node as? Ball,
                    let ballB = contact.bodyB.node as? Ball {
                    if ballA.value == ballB.value {
                        ballA.increase()
                        ballB.removeFromParent()
                        shootContact = true
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
        if (whiteBall.physicsBody!.velocity.length() < RestBias) {
            if status == .Rolling {
                setStatusAiming()
            } else if status == .Shooting {
                if shootContact {
                    setStatusAiming()
                } else {
                    rollBall()
                }
            }
        }
    }
}
