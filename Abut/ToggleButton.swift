//
//  ToggleButton.swift
//  Abut
//
//  Created by Klemenz, Oliver on 26.09.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

class ToggleButton : SKShapeNode {
    
    var iconOnImage: SKSpriteNode!
    var iconOffImage: SKSpriteNode!
    var pressed: ButtonPressedType?
    var state: Bool = false {
        didSet {
            if state {
                iconOnImage.isHidden = false
                iconOffImage.isHidden = true
            } else {
                iconOnImage.isHidden = true
                iconOffImage.isHidden = false
            }
        }
    }
    
    init(iconOn: String, iconOff: String, width: CGFloat, height: CGFloat, corner: CGFloat, pressed: ButtonPressedType?) {
        super.init()
        
        self.pressed = pressed
        
        zPosition = 2000001
        
        path = CGPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: height),
                      cornerWidth: corner, cornerHeight: corner, transform: nil)
        strokeColor = SKColor.white
        fillColor = SKColor.clear
        
        iconOnImage = SKSpriteNode(imageNamed: iconOn)
        iconOnImage.isHidden = true
        addChild(iconOnImage)
        iconOffImage = SKSpriteNode(imageNamed: iconOff)
        iconOffImage.isHidden = false
        addChild(iconOffImage)
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
                    state = !state
                    pressed()
                }
            }
        }
        fillColor = .clear
    }
}
