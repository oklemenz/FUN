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
    
    let width: CGFloat = 10.0
    
    var label: SKLabelNode!
    var outline: SKLabelNode!
    
    var text: String = "" {
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
        outline = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        outline.zPosition = 10000
        outline.fontColor = .white
        outline.fontSize = 35
        addChild(outline)
        
        label = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        label.zPosition = 10001
        label.position = CGPoint(x: 0, y: width - 1)
        label.fontSize = 35
        label.fontColor = .white
        outline.addChild(label)
        
        render()
    }
    
    func render() {
        outline.text = text
        outline.addStroke(color: .black, width: width)
        label.text = text
    }
}
