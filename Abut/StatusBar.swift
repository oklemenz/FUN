//
//  StatusBar.swift
//  Abut
//
//  Created by Klemenz, Oliver on 10.08.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

class StatusBar : SKNode {
    
    var score: Label!
    var scoreValue: Int = 0 { // < 1000000
        didSet {
            score.text = "\(scoreValue)"
            if scoreValue > highscoreValue {
                highscoreValue = scoreValue
            }
        }
    }
    
    // TODO: Crown Icon
    var highscore: Label!
    var highscoreValue: Int = 0 { // < 1000000
        didSet {
            highscore.text = "\(highscoreValue)"
        }
    }
    
    // TODO: Rocket Icon
    var multiplier: Label!
    var multiplierValue: Int = 1 {
        didSet {
            multiplier.text = multiplierValue > 1 ? "\(multiplierValue)x" : ""
        }
    }
    
    override init() {
        super.init()
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
        highscore.position = CGPoint(x: w2 - 55, y: BAR_HEIGHT / 2 + 0)
        addChild(highscore)
        
        multiplier = Label(text: "")
        multiplier.fontSize = .s
        multiplier.position = CGPoint(x: -w2 + 55, y: BAR_HEIGHT / 2 + 0)
        addChild(multiplier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}