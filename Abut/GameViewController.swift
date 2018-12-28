//
//  GameViewController.swift
//  Abut
//
//  Created by Klemenz, Oliver on 17.07.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

class GameViewController: UIViewController, GKGameCenterControllerDelegate, GameDelegate {

    static var splashTextureMap: [String: SKTexture] = [:]
    
    let LEADERBOARD_SCORE_ID = "de.oklemenz.fun.Leaderboard"
    let LEADERBOARD_MULTIPLIER_ID = "de.oklemenz.fun.Leaderboard.Multiplier"
    let LEADERBOARD_COLOR_ID = "de.oklemenz.fun.Leaderboard.Color"
    
    var gcEnabled = false
    var gcDefaultLeaderBoard = ""
    
    var gameScene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .resizeFill
                // Present the scene
                view.presentScene(scene)
                gameScene = scene as? GameScene
                gameScene.gameDelegate = self
            }
            view.ignoresSiblingOrder = true
            view.showsFPS = false
            view.showsNodeCount = false
            view.showsPhysics = false
            
            loadContext()
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    func loadContext() {
        gameScene.loadContext()
    }
    
    func saveContext() {
        gameScene.saveContext()
    }
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if let viewController = viewController {
                self.present(viewController, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                self.gcEnabled = true
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error == nil {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
                })
            } else {
                self.gcEnabled = false
            }
        }
    }
        
    func submitScore(score: Int) {
        if self.gcEnabled {
            let currentScore = GKScore(leaderboardIdentifier: LEADERBOARD_SCORE_ID)
            currentScore.value = Int64(score)
            GKScore.report([currentScore], withCompletionHandler: { (error) in
            })
        }
    }
    
    func submitMultiplier(multiplier: Int) {
        if self.gcEnabled {
            let currentScore = GKScore(leaderboardIdentifier: LEADERBOARD_MULTIPLIER_ID)
            currentScore.value = Int64(multiplier)
            GKScore.report([currentScore], withCompletionHandler: { (error) in
            })
        }
    }
    
    func submitColor(color: Int) {
        if self.gcEnabled {
            let currentScore = GKScore(leaderboardIdentifier: LEADERBOARD_COLOR_ID)
            currentScore.value = Int64(color)
            GKScore.report([currentScore], withCompletionHandler: { (error) in
            })
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func openGameCenter() {
        if self.gcEnabled {
            let viewController = GKGameCenterViewController()
            viewController.gameCenterDelegate = self
            viewController.viewState = .leaderboards
            viewController.leaderboardIdentifier = LEADERBOARD_SCORE_ID
            present(viewController, animated: true, completion: nil)
        }
    }
    
    func openSharing(score: Int) {
        let scoreText = score == 1 ? "\(score) point" : "\(score) points"
        let text = "Hi, I just scored \(scoreText) in the iOS game #f.u.n."
        let url = URL(string:"https://itunes.apple.com/us/app/fun/id1332716706?mt=8")!
        let view = splatterView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            let image = self.screenshot(view)
            let activityViewController = UIActivityViewController(activityItems: [text, url, image], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func screenshot(_ view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if (image != nil) {
            return image!
        }
        return UIImage()
    }
    
    func splatterView() -> UIView {
        let view = SKView(frame: self.view.bounds)
        let scene = SKScene()
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.scaleMode = .resizeFill
        
        gameScene.board.children.forEach { (node) in
            if let block = node as? Block {
                let name = "splash" + String(format: "%02d", Int.random(in: 1...25))
                let node = SKSpriteNode(texture: cachedTexture(name: name, value: block.value, color: block.color))
                node.position = block.position
                node.xScale = 0.4 + CGFloat(Float.random(in: -0.2...0.2))
                node.yScale = 0.4 + CGFloat(Float.random(in: -0.2...0.2))
                node.zRotation = CGFloat(Float.random(in: -Float.pi...Float.pi))
                scene.addChild(node)
            }
        }
        var balls: [Ball] = []
        gameScene.board.children.forEach { (node) in
            if let ball = node as? Ball {
                balls.append(ball)
            }
        }
        balls.sort { (ball1, ball2) -> Bool in
            if ball1.value == 0 || ball2.value == 0 {
                return true
            }
            return ball1.value < ball2.value
        }
        for ball in balls {
            let name = "splash" + String(format: "%02d", Int.random(in: 1...25))
            let node = SKSpriteNode(texture: cachedTexture(name: name, value: ball.value, color: ball.color))
            node.position = ball.position
            node.xScale = 0.4 + CGFloat(Float.random(in: -0.2...0.2))
            node.yScale = 0.4 + CGFloat(Float.random(in: -0.2...0.2))
            node.zRotation = CGFloat(Float.random(in: -Float.pi...Float.pi))
            scene.addChild(node)
        }
        
        let logo = Logo()
        logo.position = CGPoint(x: 0, y: -20)
        scene.addChild(logo)
        
        view.presentScene(scene)
        return view
    }
    
    func cachedTexture(name: String, value: Int, color: SKColor) -> SKTexture {
        let cache = "\(name)~\(value)"
        var texture = GameViewController.splashTextureMap[cache]
        if texture == nil {
            let image = UIImage(named: name)
            texture = SKTexture(image: image!.colored(color: color))
            GameViewController.splashTextureMap[cache] = texture
        }
        return texture!
    }
    
    func clearSplashTextures() {
        GameViewController.splashTextureMap.removeAll()
    }
    
    override func didReceiveMemoryWarning() {
        clearSplashTextures()
        Border.clearScreenTextures()
    }
}
