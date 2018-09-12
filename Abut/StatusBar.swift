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
    func didPressPause()
}

class StatusBar : SKNode {
    
    weak var delegate: StatusBarDelegate?
    
    var score: Label!
    var scoreValue: Int = 0 { // < 1000000
        didSet {
            score.text = "\(scoreValue)"
            if scoreValue > highscoreValue {
                highscoreValue = scoreValue
            }
        }
    }
    
    var highscore: Label!
    var highscoreValue: Int = 0 { // < 1000000
        didSet {
            highscore.text = "\(highscoreValue)"
        }
    }
    var highscoreIcon: SKSpriteNode!
    
    var multiplier: Label!
    var multiplierValue: Int = 1 {
        didSet {
            multiplier.text = multiplierValue > 1 ? "\(multiplierValue)x" : ""
            multiplierIcon.isHidden = multiplierValue <= 1
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

        position = CGPoint(x: 0, y: h2 - BAR_HEIGHT - CORNER_RADIUS)

        score = Label(text: "\(scoreValue)")
        score.position = CGPoint(x: 0, y: BAR_HEIGHT / 2)
        addChild(score)

        highscore = Label(text: "\(highscoreValue)")
        highscore.fontSize = .s
        highscore.position = CGPoint(x: w2 - 50, y: BAR_HEIGHT / 2 + 0)
        addChild(highscore)
        
        highscoreIcon = SKSpriteNode(imageNamed: "crown")
        highscoreIcon.position = CGPoint(x: w2 - 50, y: BAR_HEIGHT / 2 + 42)
        highscoreIcon.xScale = 0.5
        highscoreIcon.yScale = 0.5
        highscoreIcon.zPosition = 10000
        addChild(highscoreIcon)
        
        multiplier = Label(text: "")
        multiplier.fontSize = .s
        multiplier.position = CGPoint(x: -w2 + 60, y: BAR_HEIGHT / 2 + 0)
        addChild(multiplier)
        
        multiplierIcon = SKSpriteNode(imageNamed: "rocket")
        multiplierIcon.position = CGPoint(x: -w2 + 60, y: BAR_HEIGHT / 2 + 42)
        multiplierIcon.xScale = 0.5
        multiplierIcon.yScale = 0.5
        multiplierIcon.zPosition = 10000
        multiplierIcon.isHidden = true
        addChild(multiplierIcon)
        
        pauseIcon = SKSpriteNode(imageNamed: "pause")
        pauseIcon.position = CGPoint(x: -w2 + 25, y: BAR_HEIGHT / 2 + 20)
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
                delegate?.didPressPause()
            }
        }
    }
    
    func save() -> [String:Any] {
        var data: [String:Any] = [:]
        data["score"] = scoreValue
        data["highscore"] = highscoreValue
        data["multi"] = multiplierValue
        return data
    }
    
    func load(data: [String:Any]) {
        scoreValue = data["score"] as! Int
        highscoreValue = data["highscore"] as! Int
        multiplierValue = data["multi"] as! Int
    }
}
