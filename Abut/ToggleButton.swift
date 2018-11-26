//
//  ToggleButton.swift
//  Abut
//
//  Created by Klemenz, Oliver on 26.09.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit
import AudioToolbox

class ToggleButton : SKShapeNode {
    
    var iconOnImage: SKSpriteNode!
    var iconOffImage: SKSpriteNode!
    var color: SKColor?
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
    
    init(iconOn: String, iconOff: String, width: CGFloat, height: CGFloat, corner: CGFloat, color: SKColor? = nil, pressed: ButtonPressedType?) {
        super.init()
        
        self.pressed = pressed
        self.color = color
        
        zPosition = 2000001
        isUserInteractionEnabled = true
        path = UIBezierPath(roundedRect: CGRect(x: -width / 2.0, y: -height / 2.0, width: width, height: height),
                            cornerRadius: 15).cgPath
        lineWidth = BORDER_LINE_WIDTH
        strokeColor = SKColor.darkGray
        fillColor = self.color ?? SKColor.clear
        
        iconOnImage = SKSpriteNode(imageNamed: iconOn)
        iconOnImage.isHidden = true
        iconOnImage.xScale = 0.7
        iconOnImage.yScale = 0.7
        addChild(iconOnImage)
        iconOffImage = SKSpriteNode(imageNamed: iconOff)
        iconOffImage.isHidden = false
        iconOffImage.xScale = 0.7
        iconOffImage.yScale = 0.7
        addChild(iconOffImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fillColor = self.color !== nil ? self.color!.withAlphaComponent(0.25) : .darkGray
        iconOnImage.position = CGPoint(x: 0, y: -2)
        iconOffImage.position = CGPoint(x: 0, y: -2)
        let peek = SystemSoundID(1519)
        AudioServicesPlaySystemSound(peek)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: parent!)
            if contains(location) {
                fillColor = self.color !== nil ? self.color!.withAlphaComponent(0.25) : .darkGray
            } else {
                fillColor = self.color ?? SKColor.clear
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: parent!)
            if contains(location) {
                if let pressed = pressed {
                    state = !state
                    pressed()
                }
            }
        }
        fillColor = self.color ?? SKColor.clear
        iconOnImage.position = .zero
        iconOffImage.position = .zero
        let peek = SystemSoundID(1520)
        AudioServicesPlaySystemSound(peek)
    }
}
