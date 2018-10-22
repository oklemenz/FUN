//
//  StatusBar.swift
//  Abut
//
//  Created by Klemenz, Oliver on 10.08.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

protocol StatusBarDelegate: class {
    func reportNewHighscore(_ value: Int)
    func didReachNewHighscore(_ value: Int)
    func didPressPause()
}

class StatusBar : SKNode {
    
    weak var statusBarDelegate: StatusBarDelegate?
    
    var score: Label!
    var scoreValue: Int = 0 { // < 1000000
        didSet {
            score.text = "\(scoreValue)"
        }
    }
    
    var highscoreBeaten = false
    var highscore: Label!
    var highscoreValue: Int = 0 { // < 1000000
        didSet {
            highscore.text = "\(highscoreValue)"
        }
    }
    var highscoreIcon: SKSpriteNode!
    
    var multiplierGroup: SKNode!
    var multiplier: Label!
    var multiplierValue: Int = 0 {
        didSet {
            multiplier.text = "x\(self.multiplierValue)"
        }
    }
    var multiplierIcon: SKSpriteNode!
    
    var pauseIcon: SKSpriteNode!
    
    override init() {
        super.init()
        
        isUserInteractionEnabled = true
        
        let w = UIScreen.main.bounds.width
        let w2 = w / 2.0
        let h = UIScreen.main.bounds.height
        let h2 = h / 2.0

        position = CGPoint(x: 0, y: h2 - BAR_HEIGHT - CORNER_RADIUS + (Device.IS_IPHONE_X ? 0 : 15))

        score = Label(text: "\(scoreValue)")
        score.position = CGPoint(x: 0, y: BAR_HEIGHT / 2)
        addChild(score)

        highscore = Label(text: "\(highscoreValue)")
        highscore.fontSize = .s
        highscore.position = CGPoint(x: w2 - 50, y: BAR_HEIGHT / 2 + 0)
        addChild(highscore)
        
        highscoreIcon = SKSpriteNode(imageNamed: "crown")
        highscoreIcon.position = CGPoint(x: w2 - 50, y: BAR_HEIGHT / 2 + 40)
        highscoreIcon.xScale = 0.75
        highscoreIcon.yScale = 0.75
        highscoreIcon.zPosition = 10000
        addChild(highscoreIcon)
        
        multiplierGroup = SKNode()
        multiplierGroup.position = CGPoint(x: -w2 + 60, y: BAR_HEIGHT / 2 + 20)
        multiplierGroup.xScale = 0.0
        multiplierGroup.yScale = 0.0
        addChild(multiplierGroup)
        
        multiplierIcon = SKSpriteNode(imageNamed: "rocket")
        multiplierIcon.position = CGPoint(x: 0, y: 20)
        multiplierIcon.xScale = 0.75
        multiplierIcon.yScale = 0.75
        multiplierIcon.zPosition = 10000
        multiplierGroup.addChild(multiplierIcon)
    
        multiplier = Label(text: "")
        multiplier.position = CGPoint(x: 0, y: -20)
        multiplier.fontSize = .s
        multiplierGroup.addChild(multiplier)
        
        pauseIcon = SKSpriteNode(imageNamed: "pause")
        pauseIcon.position = CGPoint(x: -w2 + 25, y: BAR_HEIGHT / 2 + 18)
        pauseIcon.xScale = 1.0
        pauseIcon.yScale = 1.0
        pauseIcon.zPosition = 10000
        addChild(pauseIcon)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let node : SKNode = self.atPoint(location)
            if node == pauseIcon {
                pauseIcon.texture = SKTexture(imageNamed: "pause_pressed")
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let node : SKNode = self.atPoint(location)
            if node == pauseIcon {
                statusBarDelegate?.didPressPause()
            }
        }
        pauseIcon.texture = SKTexture(imageNamed: "pause")
    }
    
    func addScore(_ addValue: Int, animated: Bool = false) {
        if animated {
            score.run(SKAction.sequence([
                SKAction.scale(to: 1.2, duration: 0.25),
                SKAction.run {
                    self.scoreValue += addValue
                    if Settings.instance.sound {
                        self.run(scoreSound)
                    }
                    self.setHighscore(self.scoreValue, animated: true)
                },
                SKAction.scale(to: 1.0, duration: 0.25)
                ]))
        } else {
            self.scoreValue += addValue
            self.setHighscore(self.scoreValue, animated: false)
        }
    }
    
    func setHighscore(_ value: Int, animated: Bool = false) {
        if value > highscoreValue {
            if highscoreValue > 0 {
                statusBarDelegate?.reportNewHighscore(value)
            }
            if !highscoreBeaten {
                highscoreBeaten = true
                if highscoreValue > 0 {
                    statusBarDelegate?.didReachNewHighscore(value)
                }
            }
            if animated {
                highscore.run(SKAction.sequence([
                    SKAction.scale(to: 1.2, duration: 0.25),
                    SKAction.run {
                        self.highscoreValue = value
                    },
                    SKAction.scale(to: 1.0, duration: 0.25)
                    ]))
            } else {
                highscoreValue = value
            }
        }
    }
    
    func setMultiplier(_ value: Int, animated: Bool = false) {
        guard value != multiplierValue else {
            return
        }
        if animated {
            if multiplierValue < 1 && value >= 1 {
                multiplierValue = value
            }
            if value >= 1 {
                multiplierGroup.run(SKAction.sequence([
                    SKAction.scale(to: 1.2, duration: 0.25),
                    SKAction.run {
                        self.multiplierValue = value
                    },
                    SKAction.scale(to: 1.0, duration: 0.25)
                    ]))
            } else {
                multiplierGroup.run(SKAction.sequence([
                    SKAction.scale(to: 1.2, duration: 0.25),
                    SKAction.scale(to: 0.0, duration: 0.25),
                    SKAction.run {
                        self.multiplierValue = value
                    },
                    ]))
            }
        } else {
            if value >= 1 {
                multiplierValue = value
                multiplierGroup.xScale = 1.0
                multiplierGroup.yScale = 1.0
            } else {
                multiplierValue = 0
                multiplierGroup.xScale = 0.0
                multiplierGroup.yScale = 0.0
            }
        }
    }
    
    func save() -> [String:Any] {
        var data: [String:Any] = [:]
        data["score"] = scoreValue
        data["highscore"] = highscoreValue
        data["highscoreBeaten"] = highscoreBeaten
        data["multiplier"] = multiplierValue
        return data
    }
    
    func load(data: [String:Any]) {
        scoreValue = data["score"] as! Int
        highscoreValue = data["highscore"] as! Int
        highscoreBeaten = data["highscoreBeaten"] as! Bool
        setMultiplier(data["multiplier"] as! Int)
    }
    
    func reset() {
        scoreValue = 0
        highscoreBeaten = false
        setMultiplier(0)
    }
}
