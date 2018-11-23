//
//  Hand.swift
//  Abut
//
//  Created by Klemenz, Oliver on 21.11.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

class Hand: SKSpriteNode {
    
    enum HandStatus {
        case Start
        case Set
        case Move
        case Wait
        case Press
        case End
    }
    
    var start: CGPoint?
    var end: CGPoint?
    
    let offset = CGPoint(x: 107 * SIZE_MULT, y: -120 * SIZE_MULT)
    
    var status: HandStatus = .Start {
        didSet {
            switch status {
                case .Start:
                    break
                case .Set:
                    alpha = 0.0
                    delay {
                        self.show {
                            self.status = .Move
                        }
                    }
                case .Move:
                    move()
                case .Wait:
                    self.removeAllActions()
                    hide()
                case .Press:
                    show {
                        self.press()
                    }
                case .End:
                    self.removeAllActions()
                    hide {
                        self.removeFromParent()
                    }
            }
        }
    }
    
    init() {
        let texture = SKTexture(imageNamed: "hand")
        super.init(texture: texture, color: UIColor.white, size: texture.size())
        zPosition = 5000
        alpha = 0.0
        xScale = 0.35 * SIZE_MULT
        yScale = 0.35 * SIZE_MULT
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func delay(completed: (() -> ())? = nil) {
        run(SKAction.sequence([
            SKAction.wait(forDuration: 0.25),
            SKAction.run {
                if let completed = completed {
                    completed()
                }
            }
        ]))
    }
    
    func show(completed: (() -> ())? = nil) {
        run(SKAction.sequence([
            SKAction.fadeIn(withDuration: 0.25),
            SKAction.run {
                if let completed = completed {
                    completed()
                }
            }
        ]))
    }
    
    func hide(completed: (() -> ())? = nil) {
        run(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.25),
            SKAction.run {
                if let completed = completed {
                    completed()
                }
            }
        ]))
    }
    
    func start(_ point: CGPoint) {
        start = point
        position = point + offset
    }
    
    func end(_ point: CGPoint) {
        end = point + offset
    }
    
    func move() {
        removeAllActions()
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.run({
                if let start = self.start {
                    self.start(start)
                }
            }),
            SKAction.run({
                if let end = self.end {
                    self.run(SKAction.move(to: end, duration: 0.5))
                }
            }),
            SKAction.wait(forDuration: 1.0)
        ])))
    }
    
    func press() {
        if let start = self.start {
            self.start(start)
        }
        removeAllActions()
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run({
                self.texture = SKTexture(imageNamed: "hand_pressed")
            }),
            SKAction.wait(forDuration: 1.5),
            SKAction.run({
                self.texture = SKTexture(imageNamed: "hand")
            }),
            SKAction.wait(forDuration: 0.5)
        ])))
    }
}
