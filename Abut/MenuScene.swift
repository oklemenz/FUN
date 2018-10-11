//
//  MenuScene.swift
//  Abut
//
//  Created by Klemenz, Oliver on 10.09.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

protocol MenuDelegate : class {
    func didPressResume()
    func didPressRestart()
    func didPressSound()
    func didPressGameCenter()
    func didPressShare()
}

class MenuScene: SKNode {
    
    let border = Border()
    
    var titleLabel: Label!
    var restartButton: Button!
    var soundButton: ToggleButton!
    var gameCenterButton: Button!
    var shareButton: Button!
    var resumeButton: Button!
    
    weak var menuDelegate: MenuDelegate?
    
    override init() {
        super.init()
        
        isUserInteractionEnabled = true
        zPosition = 2000000
        
        let h = UIScreen.main.bounds.height
        let h2 = h / 2.0
        
        border.color = UIColor.darkGray
        border.board.removeFromParent()
        addChild(border)
        
        titleLabel = Label(text: "f.u.n.")
        titleLabel.fontSize = .xxxl
        titleLabel.position = CGPoint(x: 0, y: h2 - 200)
        addChild(titleLabel)
        
        restartButton = Button(icon: "restart", width: 100, height: 50, corner: 10, color: COLOR_RED, pressed: didPressRestart)
        restartButton.position = CGPoint(x: -75, y: 50)
        addChild(restartButton)
        
        soundButton = ToggleButton(iconOn: "sound_on", iconOff: "sound_off", width: 100, height: 50, corner: 10, color: COLOR_PINK, pressed: didPressSound)
        soundButton.position = CGPoint(x: 75, y: 50)
        addChild(soundButton)
        
        gameCenterButton = Button(icon: "leaderboard", width: 100, height: 50, corner: 10, color: COLOR_ORANGE, pressed: didPressGameCenter)
        gameCenterButton.position = CGPoint(x: -75, y: -50)
        addChild(gameCenterButton)
        
        shareButton = Button(icon: "share", width: 100, height: 50, corner: 10, color: COLOR_BLUE, pressed: didPressShare)
        shareButton.position = CGPoint(x: 75, y: -50)
        addChild(shareButton)
        
        resumeButton = Button(icon: "resume", width: 200, height: 50, corner: 10, color: COLOR_GREEN, pressed: didPressResume)
        resumeButton.position = CGPoint(x: 0, y: -200)
        addChild(resumeButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        menuDelegate?.didPressResume()
    }
    
    func didPressResume() {
        menuDelegate?.didPressResume()
    }
    
    func didPressGameCenter() {
        menuDelegate?.didPressGameCenter()
    }
    
    func didPressRestart() {
        menuDelegate?.didPressRestart()
    }
    
    func didPressSound() {
        menuDelegate?.didPressSound()
    }
    
    func didPressShare() {
        menuDelegate?.didPressShare()
    }
}
