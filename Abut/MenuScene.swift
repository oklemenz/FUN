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
    
    var restartButton: Button!
    var soundButton: ToggleButton!
    var gameCenterButton: Button!
    var shareButton: Button!
    var resumeButton: Button!
    
    weak var menuDelegate: MenuDelegate?
    
    override init() {
        super.init()
        
        addChild(border)
        
        restartButton = Button(icon: "restart", width: 100, height: 50, corner: 20, pressed: menuDelegate?.didPressRestart)
        restartButton.position = CGPoint(x: -150, y: 100)
        addChild(restartButton)
        
        soundButton = ToggleButton(iconOn: "sound_on", iconOff: "sound_off", width: 100, height: 50, corner: 20, pressed: menuDelegate?.didPressSound)
        soundButton.position = CGPoint(x: 150, y: 100)
        addChild(soundButton)
        
        gameCenterButton = Button(icon: "leaderboard", width: 100, height: 50, corner: 20, pressed: menuDelegate?.didPressGameCenter)
        gameCenterButton.position = CGPoint(x: -150, y: -100)
        addChild(gameCenterButton)
        
        shareButton = Button(icon: "restart", width: 100, height: 50, corner: 20, pressed: menuDelegate?.didPressShare)
        shareButton.position = CGPoint(x: 150, y: -100)
        addChild(shareButton)
        
        resumeButton = Button(icon: "resume", width: 200, height: 50, corner: 20, pressed: menuDelegate?.didPressResume)
        resumeButton.position = CGPoint(x: 0, y: -200)
        addChild(resumeButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
