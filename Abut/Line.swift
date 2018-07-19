//
//  Line.swift
//  Abut
//
//  Created by Klemenz, Oliver on 17.07.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

class Line : SKShapeNode {

    let pattern: [CGFloat] = [1.0, 12.0]
    var length: CGFloat = 0
    
    var startPoint: CGPoint? {
        didSet {
            dashedLine()
        }
    }
    
    var endPoint: CGPoint? {
        didSet {
            dashedLine()
        }
    }
    
    var phase: CGFloat = 0 {
        didSet {
            dashedLine()
        }
    }
    
    override init() {
        super.init()
        zPosition = 100
        strokeColor = SKColor.white
        length = pattern.reduce(0, +)
        
        dashedLine()
        animate()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func dashedLine() {
        if let startPoint = startPoint, let endPoint = endPoint {
            let bezierPath = UIBezierPath()
            bezierPath.move(to: startPoint)
            bezierPath.addLine(to: endPoint)
            path = bezierPath.cgPath.copy(dashingWithPhase: phase, lengths: pattern)
            lineWidth = 4.0
            lineCap = .round
        } else {
            path = nil
        }
    }
    
    func animate() {
        let action = SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: 0.05),
            SKAction.run {
                self.phase -= 1
                if (self.phase < 0) {
                    self.phase = self.length
                }
                self.dashedLine()
            }
        ]))
        run(action)
    }
}
