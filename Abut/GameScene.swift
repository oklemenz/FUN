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

let CORNER_RADIUS: CGFloat = Device.IS_IPHONE ? 40.0 : 20.0
let BORDER_LINE_WIDTH: CGFloat = 2.5
let BAR_HEIGHT: CGFloat = 50.0 + (Device.IS_IPHONE_X ? NOTCH_HEIGHT : 0.0)
let BALL_RADIUS: CGFloat = 16.0 * (Device.IS_IPAD ? 1.5 : 1)

let COLOR_RED = SKColor(r: 255, g: 59, b: 48)
let COLOR_ORANGE = SKColor(r: 255, g: 149, b: 0)
let COLOR_YELLOW = SKColor(r: 255, g: 204, b: 0)
let COLOR_GREEN = SKColor(r: 76, g: 217, b: 100)
let COLOR_TEAL_BLUE = SKColor(r: 90, g: 200, b: 250)
let COLOR_BLUE = SKColor(r: 0, g: 122, b: 255)
let COLOR_PURPLE = SKColor(r: 88, g: 86, b: 214)
let COLOR_PINK = SKColor(r: 255, g: 45, b: 85)

protocol GameDelegate: class {
    func submitScore(score: Int)
    func submitMultiplier(multiplier: Int)
    func openGameCenter()
    func openSharing(score: Int)
}

class GameScene: SKScene, SKPhysicsContactDelegate, BoardDelegate, StatusBarDelegate, MenuDelegate, SplashDelegate {
    
    let rootNode = SKNode()
    let statusBar = StatusBar()
    let board = Board()
    let border = Border()

    var menu: Menu?
    var splash: Splash!
    
    weak var gameDelegate: GameDelegate?
    
    var multiplierGroup: SKNode! = nil
    var multiplierLabel1: Label! = nil
    var multiplierLabel2: Label! = nil
    var notificationLabel: Label! = nil
    
    var loaded = false
    var pause = false
    var review = false
    var shaking = false
    
    override func didMove(to view: SKView) {
        statusBar.statusBarDelegate = self
        board.boardDelegate = self
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.speed = 0.9
        
        rootNode.addChild(statusBar)
        rootNode.addChild(board)
        rootNode.addChild(border)
        border.color = Ball.colorForValue(1)
        addChild(rootNode)
        
        splash = Splash()
        splash.splashDelegate = self
        addChild(splash)
    }
    
    func splashDidFinish() {
        splash.run(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.removeFromParent(),
            SKAction.run({
                self.run(SKAction.sequence([
                    SKAction.wait(forDuration: 1.0),
                    SKAction.run {
                        if !self.loaded {
                            self.board.start()
                        }
                    }
                    ]))
                
                self.run(SKAction.sequence([
                    SKAction.wait(forDuration: 5.0 * 60.0),
                    SKAction.run {
                        if !self.review {
                            self.review = true
                            SKStoreReviewController.requestReview()
                        }
                    }
                    ]))
            })
        ]))
    }
    
    func shake(duration: Float = 0.5) {
        if !shaking {
            shaking = true
            rootNode.run(SKAction.shake(initialPosition: rootNode.position, duration: duration, completed: {
                self.shaking = false
            }))
        }
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
    
    func showNotificationLabel(_ text: String) {
        if notificationLabel == nil {
            notificationLabel = Label()
            notificationLabel.fontSize = .s
            let h = UIScreen.main.bounds.height - BAR_HEIGHT
            let h4 = h / 4.0
            notificationLabel.position = CGPoint(x: 0, y: h4)
            notificationLabel.xScale = 0.0
            notificationLabel.yScale = 0.0
            addChild(notificationLabel)
        }
        notificationLabel.text = text
        notificationLabel!.run(SKAction.sequence([
            SKAction.scale(to: 1.2, duration: 0.5),
            SKAction.scale(to: 1.0, duration: 0.25),
            SKAction.wait(forDuration: 2.0),
            SKAction.run {
                self.notificationLabel = nil
            },
            SKAction.scale(to: 1.2, duration: 0.25),
            SKAction.scale(to: 0.0, duration: 0.25),
            SKAction.removeFromParent()
            ]))
    }
    
    func reportScore(_ value: Int) {
        gameDelegate?.submitScore(score: value)
    }
    
    func didReachNewHighscore(_ value: Int) {
        showNotificationLabel("New high score reached!")
        if Settings.instance.sound {
            run(highscoreSound)
        }
    }
    
    func didPressPause() {
        if !pause {
            pause = true
            if menu == nil {
                menu = Menu()
                menu?.menuDelegate = self
            }
            if Settings.instance.sound {
                run(buttonSound)
            }
            menu?.soundButton?.state = Settings.instance.sound
            menu?.highscore.text = "\(statusBar.highscoreValue)"
            self.menu?.alpha = 0
            self.addChild(self.menu!)
            self.menu?.run(SKAction.fadeIn(withDuration: 0.5))
        }
    }
    
    func didResumePause() {
        if pause {
            pause = false
            menu?.run(SKAction.sequence([
                SKAction.fadeOut(withDuration: 0.5),
                SKAction.removeFromParent()]))
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
        let addValue = value * (multiplier > 1 ? multiplier : 1)
        score.text = "\(addValue)"
        score.position = CGPoint(x: contactPoint.x, y: contactPoint.y)
        var point = statusBar.score.convert(statusBar.score.position, to: self)
        point = CGPoint(x: point.x, y: point.y - 40)
        let distance = score.position.distanceTo(point)
        score.run(SKAction.sequence([
            SKAction.move(to: point, duration: TimeInterval(distance / 750)),
            SKAction.run({
                self.statusBar.addScore(addValue, animated: true)
            }),
            SKAction.removeFromParent()
        ]))
        addChild(score)
    }
    
    func didUpdateColor(color: UIColor) {
        border.color = color
    }

    func didUpdateMultiplier(multiplier: Int, roundMultiplier: Int) {
        gameDelegate?.submitMultiplier(multiplier: multiplier)
        guard multiplier > 1 else {
            if multiplier == 1 {
               self.statusBar.setMultiplier(multiplier, animated: true)
            }
            return
        }
        if multiplierGroup == nil {
            multiplierGroup = SKNode()
            multiplierGroup.position = CGPoint(x: 0, y: -BAR_HEIGHT / 2.0)
            multiplierGroup.xScale = 0.0
            multiplierGroup.yScale = 0.0
            multiplierLabel1 = Label()
            multiplierGroup.addChild(multiplierLabel1)
            multiplierLabel2 = Label()
            multiplierGroup.addChild(multiplierLabel2)
            addChild(multiplierGroup!)
        }
        let combo = "x\(multiplier) Combo!"
        if roundMultiplier <= 1 {
            multiplierLabel1.position = CGPoint(x: 0, y: 0)
            multiplierLabel2.position = CGPoint(x: 0, y: 0)
            multiplierLabel1.text = combo
            multiplierLabel2.text = ""
        } else {
            multiplierLabel1.position = CGPoint(x: 0, y: 20)
            multiplierLabel2.position = CGPoint(x: 0, y: -20)
            if roundMultiplier == 2 {
                multiplierLabel1.text = ["Great!", "Beautiful!", "Wonderful!"].randomElement()!
                multiplierLabel2.text = combo
            } else if roundMultiplier == 3 {
                multiplierLabel1.text = ["Amazing!", "Awesome!"].randomElement()!
                multiplierLabel2.text = combo
                shake()
            } else if roundMultiplier >= 4 {
                multiplierLabel1.text = ["Fantastic!", "Incredible!"].randomElement()!
                multiplierLabel2.text = combo
                shake()
                vibrate()
            }
        }
        multiplierGroup!.run(SKAction.sequence([
            SKAction.scale(to: 1.2, duration: 0.5),
            SKAction.run {
                self.statusBar.setMultiplier(multiplier, animated: true)
            },
            SKAction.scale(to: 1.0, duration: 0.25),
            SKAction.wait(forDuration: 2.0),
            SKAction.run {
                self.multiplierGroup = nil
                self.multiplierLabel1 = nil
                self.multiplierLabel2 = nil
            },
            SKAction.scale(to: 1.2, duration: 0.25),
            SKAction.scale(to: 0.0, duration: 0.25),
            SKAction.removeFromParent()
            ]))
    }
    
    func didUnlockNewColor(color: Int) {
        showNotificationLabel("New color: \(Ball.colorNameForValue(color))!")
    }
    
    func didResetMultiplier() {
        self.statusBar.setMultiplier(0, animated: true)
    }
    
    func loadContext() {
        if let data = UserDefaults.standard.value(forKey: "data") as? [String:Any] {
            let boardData = data["board"] as! [String:Any]
            let statusData = data["status"] as! [String:Any]
            board.load(data: boardData)
            statusBar.load(data: statusData)
            review = data["review"] as! Bool
            Settings.instance.sound = data["sound"] as! Bool
            loaded = true
        }
    }
    
    func saveContext() {
        var data: [String:Any] = [:]
        data["board"] = board.save()
        data["status"] = statusBar.save()
        data["review"] = review
        data["sound"] = Settings.instance.sound
        UserDefaults.standard.set(data, forKey: "data")
        UserDefaults.standard.synchronize()
    }
    
    func didPressResume() {
        didResumePause()
    }
    
    func didPressGameCenter() {
        gameDelegate?.openGameCenter()
    }
    
    func didPressRestart() {
        border.color = Ball.colorForValue(1)
        statusBar.reset()
        board.reset()
        didResumePause()
        run(SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.run {
                self.board.new()
            }
        ]))
    }
    
    func didPressSound() {
        if let menu = menu {
            Settings.instance.sound = menu.soundButton!.state
        }
    }
    
    func didPressShare() {
        gameDelegate?.openSharing(score: statusBar.scoreValue)
    }
}
