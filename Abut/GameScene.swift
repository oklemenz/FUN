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
import StoreKit

// Screen sizes
let NOTCH_WIDTH: CGFloat = Device.IS_IPHONE_XR ? 230.0 : 209.0
let NOTCH_HEIGHT: CGFloat = Device.IS_IPHONE_XR ? 33.0 : 30.0
let NOTCH_RADIUS_1: CGFloat = Device.IS_IPHONE_XR ? 26.0 : 20.0
let NOTCH_RADIUS_2: CGFloat = 6.0

let CORNER_RADIUS: CGFloat = 40.0
let BORDER_LINE_WIDTH: CGFloat = 2.5
let BAR_HEIGHT: CGFloat = 50.0 + (Device.IS_IPHONE_X ? NOTCH_HEIGHT : 0.0)
let BALL_RADIUS: CGFloat = 16.0 * (Device.IS_IPAD ? 2 : 1)

class GameScene: SKScene, SKPhysicsContactDelegate, BoardDelegate, StatusBarDelegate {
    
    let statusBar = StatusBar()
    let board = Board()
    let border = Border()
    
    var menuScene: MenuScene?
    
    var loaded = false
    var pause = false
    var reviewRequested = false
    
    override func didMove(to view: SKView) {
        statusBar.delegate = self
        board.delegate = self
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.speed = 0.9
        
        addChild(statusBar)
        addChild(board)
        addChild(border)

        run(SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.run {
                if !self.loaded {
                    self.board.start()
                }
            }
        ]))
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 5.0 * 60.0),
            SKAction.run {
                if !self.reviewRequested {
                    self.reviewRequested = true
                    SKStoreReviewController.requestReview()
                }
            }
        ]))
    }
    
    func shake(duration: Float) {
        let amplitudeX:Float = 10
        let amplitudeY:Float = 6
        let numberOfShakes = duration / 0.04
        var actionsArray:[SKAction] = []
        for _ in 1...Int(numberOfShakes) {
            let moveX = Float(arc4random_uniform(UInt32(amplitudeX))) - amplitudeX / 2
            let moveY = Float(arc4random_uniform(UInt32(amplitudeY))) - amplitudeY / 2
            let shakeAction = SKAction.moveBy(x: CGFloat(moveX), y: CGFloat(moveY), duration: 0.02)
            shakeAction.timingMode = SKActionTimingMode.easeOut
            actionsArray.append(shakeAction)
            actionsArray.append(shakeAction.reversed())
        }
        let actionSeq = SKAction.sequence(actionsArray)
        run(actionSeq)
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
    
    func didPressPause() {
        pause = !pause
        board.isPaused = pause
        if pause {
            if menuScene == nil {
                menuScene = MenuScene()
                addChild(menuScene!)
            }
            menuScene?.alpha = 0.0
            menuScene?.run(SKAction.fadeIn(withDuration: 0.5))
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        board.detectCollision(contact)
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        board.detectCollision(contact)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if board.status == .Aiming {
            if let touch = touches.first {
                let location = touch.location(in: board)
                board.pointTouched(position: location, began: true)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if board.status == .Aiming {
            if let touch = touches.first {
                board.pointTouched(position: touch.location(in: board))
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if board.status == .Aiming {
            if let touch = touches.first {
                board.pointTouched(position: touch.location(in: board))
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if board.status == .Aiming {
        }
    }
   
    override func update(_ currentTime: TimeInterval) {
        board.update()
    }
    
    func didCollideBall(contactPoint: CGPoint, value: Int, multiplier: Int) {
        let score = Label()
        score.text = "\(value)"
        score.position = CGPoint(x: contactPoint.x, y: contactPoint.y + 20)
        score.run(SKAction.sequence([
            SKAction.move(to: statusBar.score.convert(statusBar.score.position, to: self), duration: 1.0),
            SKAction.run({
                self.statusBar.score.run(SKAction.sequence([
                    SKAction.scale(to: 1.2, duration: 0.25),
                    SKAction.run {
                        self.statusBar.scoreValue += value * self.board.multiplier
                    },
                    SKAction.scale(to: 1.0, duration: 0.25)
                ]))
            }),
            SKAction.removeFromParent()
        ]))
        addChild(score)
    }
    
    func didUpdateColor(color: UIColor) {
        border.color = color
    }

    func didUpdateMultiplier(multiplier: Int) {
        // TODO: Zoom in Combo label...
        statusBar.multiplierValue = multiplier
    }
    
    func loadContext() {
        if let data = UserDefaults.standard.value(forKey: "data") as? [String:Any] {
            reviewRequested = data["review"] as! Bool
            let boardData = data["board"] as! [String:Any]
            let statusData = data["status"] as! [String:Any]
            board.load(data: boardData)
            statusBar.load(data: statusData)
            loaded = true
        }
    }
    
    func saveContext() {
        var data: [String:Any] = [:]
        data["board"] = board.save()
        data["status"] = statusBar.save()
        data["review"] = reviewRequested
        UserDefaults.standard.set(data, forKey: "data")
        UserDefaults.standard.synchronize()
    }
}
