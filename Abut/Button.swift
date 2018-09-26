//
//  MenuButton.swift
//  Abut
//
//  Created by Klemenz, Oliver on 26.09.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

typealias ButtonPressedType = () -> ()

class Button : SKShapeNode {
    
    var iconImage: SKSpriteNode!
    var pressed: ButtonPressedType?
    
    init(icon: String, width: CGFloat, height: CGFloat, corner: CGFloat, pressed: ButtonPressedType?) {
        super.init()
        
        self.pressed = pressed
        
        zPosition = 2000001
        
        path = CGPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: height),
                      cornerWidth: corner, cornerHeight: corner, transform: nil)
        strokeColor = SKColor.white
        fillColor = SKColor.clear
        
        iconImage = SKSpriteNode(imageNamed: icon)
        addChild(iconImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fillColor = .darkGray
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if contains(location) {
                fillColor = .darkGray
            } else {
                fillColor = .clear
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if contains(location) {
                if let pressed = pressed {
                    pressed()
                }
            }
        }
        fillColor = .clear
    }
}
