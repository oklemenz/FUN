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
    var color: SKColor?
    var pressed: ButtonPressedType?

    init(icon: String, width: CGFloat, height: CGFloat, corner: CGFloat, color: SKColor? = nil, pressed: ButtonPressedType?) {
        super.init()
        
        self.pressed = pressed
        self.color = color
        
        zPosition = 2000001
        isUserInteractionEnabled = true
        path = UIBezierPath(roundedRect: CGRect(x: -width / 2.0, y: -height / 2.0, width: width, height: height),
                            cornerRadius: 15).cgPath
        strokeColor = SKColor.lightGray
        fillColor = self.color ?? SKColor.clear
        
        iconImage = SKSpriteNode(imageNamed: icon)
        iconImage.xScale = 0.7
        iconImage.yScale = 0.7
        addChild(iconImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fillColor = self.color !== nil ? self.color!.withAlphaComponent(0.5) : .darkGray
        iconImage.position = CGPoint(x: 0, y: -2)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: parent!)
            if contains(location) {
                fillColor = self.color !== nil ? self.color!.withAlphaComponent(0.5) : .darkGray
            } else {
                fillColor = self.color ?? .clear
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: parent!)
            if contains(location) {
                if let pressed = pressed {
                    pressed()
                }
            }
        }
        fillColor = self.color ?? .clear
        iconImage.position = .zero
    }
}
