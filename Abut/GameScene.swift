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
let CORNER_RADIUS: CGFloat = 40.0
let BAR_HEIGHT: CGFloat = 80.0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let board = Board()
    let border = Border()
    
    var score: Label!
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.speed = 0.9
        
        let texture = SKTexture(size: size.width, color1: CIColor(rgba: "#444444"), color2: CIColor(rgba: "#000000"))
        let background = SKSpriteNode(texture: texture, color: UIColor.white, size: texture.size())
        background.zPosition = 0
        background.position = CGPoint(x: 0, y: (size.height - BAR_HEIGHT - CORNER_RADIUS) / 2.0)
        background.size.width = size.width
        background.size.height = BAR_HEIGHT + CORNER_RADIUS
        addChild(background)
        
        addChild(board)
        addChild(border)
        board.border = border
        
        score = Label(text: "0")
        score.position = CGPoint(x: 0, y: UIScreen.main.bounds.height / 2 - BAR_HEIGHT / 2 - 40)
        addChild(score)
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.run {
                self.board.start()
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
    
    func didBegin(_ contact: SKPhysicsContact) {
        board.detectCollision(contact)
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        board.detectCollision(contact)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if board.status == .Aiming {
            if let touch = touches.first {
                board.pointTouched(position: touch.location(in: board), began: true)
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
}
