//
//  Dice.swift
//  Abut
//
//  Created by Klemenz, Oliver on 19.07.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

class Dice : SKSpriteNode {
    
    let distance:CGFloat = 60
    
    var eyes: [DiceEye] = []
    var value = 0 {
        willSet {
            previousValue = value
        }
        didSet {
            render(animated: true)
        }
    }
    var previousValue = 0
    
    init() {
        let texture = SKTexture(imageNamed: "dice")
        super.init(texture: texture, color: UIColor.white, size: texture.size())
        
        zPosition = 0.5
        
        for _ in 0..<6 {
            let eye = DiceEye()
            eye.position = CGPoint(x: 0, y: 0)
            addChild(eye)
            eyes.append(eye)
        }
        self.value = 6
        self.previousValue = 6
        place()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func decrease() {
        if value > 1 {
            value -= 1
        }
    }
    
    func increase() {
        if value < 6 {
            value += 1
        }
    }
    
    func place() {
        eyes[0].position = CGPoint(x: -distance, y: -distance)
        eyes[1].position = CGPoint(x: -distance, y: 0.0)
        eyes[2].position = CGPoint(x: -distance, y: distance)
        eyes[3].position = CGPoint(x: distance, y: -distance)
        eyes[4].position = CGPoint(x: distance, y: 0.0)
        eyes[5].position = CGPoint(x: distance, y: distance)
    }
    
    func render(animated: Bool = false) {
        let duration = animated ? 0.5 : 0.0
        if value < previousValue {
            switch value {
                case 0:
                    eyes[2].run(SKAction.fadeAlpha(to: 0.0, duration: duration))
                case 1:
                    eyes[2].run(SKAction.move(to: CGPoint(x: 0.0, y: 0.0), duration: duration))
                    eyes[3].run(SKAction.fadeAlpha(to: 0.0, duration: duration))
                case 2:
                    eyes[0].run(SKAction.fadeAlpha(to: 0.0, duration: duration))
                case 3:
                    eyes[0].run(SKAction.move(to: CGPoint(x: 0.0, y: 0.0), duration: duration))
                    eyes[5].run(SKAction.fadeAlpha(to: 0.0, duration: duration))
                case 4:
                    eyes[1].run(SKAction.fadeAlpha(to: 0.0, duration: duration))
                case 5:
                    eyes[1].run(SKAction.move(to: CGPoint(x: 0.0, y: 0.0), duration: duration))
                    eyes[4].run(SKAction.fadeAlpha(to: 0.0, duration: duration))
                case 6:
                    eyes[0].run(SKAction.move(to: CGPoint(x: -distance, y: -distance), duration: duration))
                    eyes[1].run(SKAction.move(to: CGPoint(x: -distance, y: 0.0), duration: duration))
                    eyes[2].run(SKAction.move(to: CGPoint(x: -distance, y: distance), duration: duration))
                    eyes[3].run(SKAction.move(to: CGPoint(x: distance, y: -distance), duration: duration))
                    eyes[4].run(SKAction.move(to: CGPoint(x: distance, y: 0.0), duration: duration))
                    eyes[5].run(SKAction.move(to: CGPoint(x: distance, y: distance), duration: duration))
                default:
                    break
            }
        } else {
            switch value {
                case 0:
                    eyes[0].position = CGPoint(x: 0.0, y: 0.0)
                    eyes[0].alpha = 0.0
                    eyes[1].position = CGPoint(x: 0.0, y: 0.0)
                    eyes[1].alpha = 0.0
                    eyes[2].position = CGPoint(x: 0.0, y: 0.0)
                    eyes[2].alpha = 0.0
                    eyes[3].position = CGPoint(x: distance, y: -distance)
                    eyes[3].alpha = 0.0
                    eyes[4].position = CGPoint(x: distance, y: 0)
                    eyes[4].alpha = 0.0
                    eyes[5].position = CGPoint(x: distance, y: distance)
                    eyes[5].alpha = 0.0
                case 1:
                    eyes[2].run(SKAction.fadeAlpha(to: 1.0, duration: duration))
                case 2:
                    eyes[2].run(SKAction.move(to: CGPoint(x: -distance, y: distance), duration: duration))
                    eyes[3].run(SKAction.fadeAlpha(to: 1.0, duration: duration))
                case 3:
                    eyes[0].run(SKAction.fadeAlpha(to: 1.0, duration: duration))
                case 4:
                    eyes[0].run(SKAction.move(to: CGPoint(x: -distance, y: -distance), duration: duration))
                    eyes[5].run(SKAction.fadeAlpha(to: 1.0, duration: duration))
                    break
                case 5:
                    eyes[1].run(SKAction.fadeAlpha(to: 1.0, duration: duration))
                    break
                case 6:
                    eyes[1].run(SKAction.move(to: CGPoint(x: -distance, y: 0.0), duration: duration))
                    eyes[4].run(SKAction.fadeAlpha(to: 1.0, duration: duration))
                    break
                default:
                    break
            }
        }
    }
    
    subscript(index: Int) -> DiceEye {
        get {
            return eyes[index];
        }
    }
}
