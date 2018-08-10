//
//  Label.swift
//  Abut
//
//  Created by Klemenz, Oliver on 08.08.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

class Label : SKNode {
    
    enum Size : CGFloat {
        case xxs = 15
        case xs = 20
        case s = 25
        case m = 30
        case l = 35
        case xl = 40
        case xxl = 45
    }
    
    private var label: SKLabelNode!
    private var outline: SKLabelNode!
    
    var fontName = "FredokaOne-Regular" { // ArialRoundedMTBold
        didSet {
            render()
        }
    }
    var fontSize: Size = .l {
        didSet {
            render()
        }
    }
    
    var width: CGFloat = 10.0 {
        didSet {
            render()
        }
    }
    
    var text: String = "" {
        didSet {
            render()
        }
    }
    
    var horizontalAlignmentMode: SKLabelHorizontalAlignmentMode = .center {
        didSet {
            render()
        }
    }
    
    init(text: String = "") {
        super.init()
        self.text = text
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        outline = SKLabelNode(fontNamed: fontName)
        outline.zPosition = 10000
        addChild(outline)
        label = SKLabelNode(fontNamed: fontName)
        label.zPosition = 10001
        outline.addChild(label)
        render()
    }
    
    func render() {
        outline.text = text
        outline.horizontalAlignmentMode = horizontalAlignmentMode
        outline.fontColor = .white
        outline.fontSize = fontSize.rawValue
        outline.addStroke(color: .black, width: width)
        label.text = text
        label.horizontalAlignmentMode = horizontalAlignmentMode
        label.position = CGPoint(x: 0, y: width - 1)
        label.fontColor = .white
        label.fontSize = fontSize.rawValue
    }
}
