//
//  Splash.swift
//  Abut
//
//  Created by Klemenz, Oliver on 16.10.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

protocol SplashDelegate : class {
    func splashDidFinish()
}

class Splash: SKNode {
    
    var border: Border!
    var logo: Logo!
    
    weak var splashDelegate: SplashDelegate?
    
    override init() {
        super.init()
        
        isUserInteractionEnabled = true
        zPosition = 2000000
        
        border = Border()
        border.color = UIColor.darkGray
        border.board.alpha = 0
        border.screen.glowWidth = 1
        border.screen.lineWidth = 5
        border.render()
        addChild(border)
        
        logo = Logo()
        logo.position = CGPoint(x: 0, y: -20)
        logo.alpha = 0.0
        logo.xScale = 0.9
        logo.yScale = 0.9
        addChild(logo)
        
        logo.run(SKAction.sequence([
            SKAction.group([
                SKAction.fadeIn(withDuration: 1.0),
                SKAction.scale(to: 1.0, duration: 1.5)
            ]),
            SKAction.fadeOut(withDuration: 1.0),
            SKAction.run {
                self.splashDelegate?.splashDidFinish()
            }
        ]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
