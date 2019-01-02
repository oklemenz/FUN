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

class Menu: SKNode {
    
    var background: SKShapeNode!
    var border: Border!
    
    var logo: Logo!
    var restartButton: Button!
    var soundButton: ToggleButton!
    var gameCenterButton: Button!
    var shareButton: Button!
    var resumeButton: Button!
    var highscoreIcon: SKSpriteNode!
    var highscore: Label!
    
    weak var menuDelegate: MenuDelegate?
    
    override init() {
        super.init()
        
        isUserInteractionEnabled = true
        zPosition = 2000000
        
        let h = UIScreen.main.bounds.height
        let h2 = h / 2.0
        let h4 = h2 / 2.0
        
        background = SKShapeNode(rectOf: UIScreen.main.bounds.size)
        background.position = CGPoint(x: 0, y: 0)
        background.strokeColor = .clear
        background.fillColor = .black
        background.zPosition = 2000000
        addChild(background)
        
        border = Border()
        border.zPosition = 2000000
        border.color = UIColor.darkGray
        border.board.alpha = 0
        border.screen.glowWidth = 1
        border.screen.lineWidth = 5
        border.render()
        addChild(border)
        
        logo = Logo()
        logo.zPosition = 2000000
        logo.position = CGPoint(x: 0, y: h4 - 20)
        addChild(logo)
        
        restartButton = Button(icon: "restart", width: 100, height: 75, corner: 10, color: COLOR_RED, pressed: didPressRestart)
        restartButton.position = CGPoint(x: -75, y: 50)
        addChild(restartButton)
        
        soundButton = ToggleButton(iconOn: "sound_on", iconOff: "sound_off", width: 100, height: 75, corner: 10, color: COLOR_TEAL_BLUE, pressed: didPressSound)
        soundButton.position = CGPoint(x: 75, y: 50)
        addChild(soundButton)
        
        gameCenterButton = Button(icon: "leaderboard", width: 100, height: 75, corner: 10, color: COLOR_ORANGE, pressed: didPressGameCenter)
        gameCenterButton.position = CGPoint(x: -75, y: -50)
        addChild(gameCenterButton)
        
        shareButton = Button(icon: "share", width: 100, height: 75, corner: 10, color: COLOR_BLUE, pressed: didPressShare)
        shareButton.position = CGPoint(x: 75, y: -50)
        addChild(shareButton)
        
        resumeButton = Button(icon: "resume", width: 250, height: 75, corner: 10, color: COLOR_GREEN, pressed: didPressResume)
        resumeButton.position = CGPoint(x: 0, y: -150)
        addChild(resumeButton)

        highscoreIcon = SKSpriteNode(imageNamed: "crown")
        highscoreIcon.position = CGPoint(x: 0, y: -250)
        highscoreIcon.zPosition = 2000001
        addChild(highscoreIcon)
        
        highscore = Label()
        highscore.fontSize = .xl
        highscore.zPosition = 2000000
        highscore.position = CGPoint(x: 0, y: -310)
        addChild(highscore)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        menuDelegate?.didPressResume()
    }
    
    func didPressResume() {
        menuDelegate?.didPressResume()
        if Settings.instance.sound {
            run(buttonSound)
        }
    }
    
    func didPressGameCenter() {
        menuDelegate?.didPressGameCenter()
        if Settings.instance.sound {
            run(buttonSound)
        }
    }
    
    func didPressRestart() {
        if Settings.instance.sound {
            run(buttonSound)
        }
        showRestartConfirmDialog()
    }
    
    func didPressSound() {
        menuDelegate?.didPressSound()
        if Settings.instance.sound {
            run(buttonSound)
        }
    }
    
    func didPressShare() {
        menuDelegate?.didPressShare()
        if Settings.instance.sound {
            run(buttonSound)
        }
    }
    
    func showRestartConfirmDialog() {
        let alertController = UIAlertController(title: "Restart Game?", message: "Do you really want to restart the game?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            self.menuDelegate?.didPressRestart()
        }
        alertController.addAction(ok)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
        }
        alertController.addAction(cancel)
        UIApplication.shared.delegate?.window??.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
