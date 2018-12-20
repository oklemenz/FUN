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
        let text = "Hi, I scored \(scoreText) in the iOS game #f.u.n."
        let image = splatterScreenshot()
        let url = URL(string:"https://itunes.apple.com/us/app/fun/id1332716706?mt=8")!
        let activityViewController = UIActivityViewController(activityItems: [text , image , url],
                                                              applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
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
    
    func splatterScreenshot() -> UIImage {
        let view = SKView(frame: self.view.bounds)
        let scene = SKScene()
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.scaleMode = .resizeFill
        
        gameScene.board.children.forEach { (node) in
            let i = Int.random(in: 1...25)
            let image = UIImage(named: "splash" + String(format: "%02d", i))
            if let block = node as? Block {
                let texture = SKTexture(image: image!.colored(color: block.color)) // Cache?
                let node = SKSpriteNode(texture: texture)
                node.position = block.position
                node.xScale = 0.4
                node.yScale = 0.4
                node.zRotation = CGFloat(Float.random(in: -Float.pi...Float.pi))
                scene.addChild(node)
            }
        }
        gameScene.board.children.forEach { (node) in
            let i = Int.random(in: 1...25)
            let image = UIImage(named: "splash" + String(format: "%02d", i))
            if let ball = node as? Ball {
                let texture = SKTexture(image: image!.colored(color: ball.color)) // Cache?
                let node = SKSpriteNode(texture: texture)
                node.position = ball.position
                node.xScale = 0.4
                node.yScale = 0.4
                node.zRotation = CGFloat(Float.random(in: -Float.pi...Float.pi))
                scene.addChild(node)
            }
        }
        
        let logo = Logo()
        logo.position = CGPoint(x: 0, y: 0)
        scene.addChild(logo)
        
        view.presentScene(scene)
        return screenshot(view)
    }
    
    override func didReceiveMemoryWarning() {
        Border.clearScreenTextures()
    }
}
