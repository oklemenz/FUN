//
//  Logo.swift
//  Abut
//
//  Created by Klemenz, Oliver on 16.10.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

class Logo : SKNode {
    
    var label: SKLabelNode!
    var outline: SKLabelNode!
    
    let fontName = "FredokaOne-Regular"
    let fontSize: Label.Size = .xxxxl
    let width: CGFloat = 10.0
    let horizontalAlignmentMode: SKLabelHorizontalAlignmentMode = .center
    
    let plainText = "f.u.n."
    let text = NSMutableAttributedString(string: "f.u.n.")
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        text.addAttribute(.font, value: UIFont(name: fontName, size: fontSize.rawValue)!, range: NSMakeRange(0, 6))
        text.addAttribute(.foregroundColor, value: COLOR_RED,       range: NSMakeRange(0, 1)) // f
        text.addAttribute(.foregroundColor, value: COLOR_ORANGE,    range: NSMakeRange(1, 1)) // .
        text.addAttribute(.foregroundColor, value: COLOR_YELLOW,    range: NSMakeRange(2, 1)) // u
        text.addAttribute(.foregroundColor, value: COLOR_GREEN,     range: NSMakeRange(3, 1)) // .
        text.addAttribute(.foregroundColor, value: COLOR_TEAL_BLUE, range: NSMakeRange(4, 1)) // n
        text.addAttribute(.foregroundColor, value: COLOR_BLUE,      range: NSMakeRange(5, 1)) // .
        
        outline = SKLabelNode(fontNamed: fontName)
        outline.zPosition = 10000
        addChild(outline)
        label = SKLabelNode(fontNamed: fontName)
        label.zPosition = 10001
        outline.addChild(label)
        render()
    }
    
    func render() {
        outline.text = plainText
        outline.horizontalAlignmentMode = horizontalAlignmentMode
        outline.fontColor = .white
        outline.fontSize = fontSize.rawValue
        outline.addStroke(color: .black, width: width)
        label.attributedText = text
        label.horizontalAlignmentMode = horizontalAlignmentMode
        label.position = CGPoint(x: 0, y: width - 1)
        label.fontColor = .white
    }
}
