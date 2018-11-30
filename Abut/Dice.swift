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
    
    static let diceTexture: SKTexture = SKTexture(imageNamed: "dice")
    
    let distance:CGFloat = 60
    
    var eyes: [DiceEye] = []
    var value = 0
    var previousValue = 0
    
    init() {
        super.init(texture: Dice.diceTexture, color: UIColor.white, size: Dice.diceTexture.size())
        
        zPosition = 0.95
        
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
        if value >= 1 {
            previousValue = value
            value -= 1
            render()
        }
    }
    
    func increase() {
        if value < 6 {
            previousValue = value
            value += 1
            render()
        }
    }

    func countUp() {
        guard value < 6 else {
            return
        }
        previousValue = value
        run(SKAction.sequence([
            SKAction.run {
                self.value += 1
                self.render(duration: self.value == 6 ? 0.5 : 0.25)
            },
            SKAction.wait(forDuration: self.value == 6 ? 0.5 : 0.25),
            SKAction.run {
                self.countUp()
            }
            ]))
    }
    
    func place() {
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
                eyes[0].position = CGPoint(x: 0.0, y: 0.0)
                eyes[0].alpha = 0.0
                eyes[1].position = CGPoint(x: 0.0, y: 0.0)
                eyes[1].alpha = 0.0
                eyes[2].position = CGPoint(x: 0.0, y: 0.0)
                eyes[2].alpha = 1.0
                eyes[3].position = CGPoint(x: distance, y: -distance)
                eyes[3].alpha = 0.0
                eyes[4].position = CGPoint(x: distance, y: 0.0)
                eyes[4].alpha = 0.0
                eyes[5].position = CGPoint(x: distance, y: distance)
                eyes[5].alpha = 0.0
            case 2:
                eyes[0].position = CGPoint(x: 0.0, y: 0.0)
                eyes[0].alpha = 0.0
                eyes[1].position = CGPoint(x: 0.0, y: 0.0)
                eyes[1].alpha = 0.0
                eyes[2].position = CGPoint(x: -distance, y: distance)
                eyes[2].alpha = 1.0
                eyes[3].position = CGPoint(x: distance, y: -distance)
                eyes[3].alpha = 1.0
                eyes[4].position = CGPoint(x: distance, y: 0.0)
                eyes[4].alpha = 0.0
                eyes[5].position = CGPoint(x: distance, y: distance)
                eyes[5].alpha = 0.0
            case 3:
                eyes[0].position = CGPoint(x: 0.0, y: 0.0)
                eyes[0].alpha = 1.0
                eyes[1].position = CGPoint(x: 0.0, y: 0.0)
                eyes[1].alpha = 0.0
                eyes[2].position = CGPoint(x: -distance, y: distance)
                eyes[2].alpha = 1.0
                eyes[3].position = CGPoint(x: distance, y: -distance)
                eyes[3].alpha = 1.0
                eyes[4].position = CGPoint(x: distance, y: 0.0)
                eyes[4].alpha = 0.0
                eyes[5].position = CGPoint(x: distance, y: distance)
                eyes[5].alpha = 0.0
            case 4:
                eyes[0].position = CGPoint(x: -distance, y: -distance)
                eyes[0].alpha = 1.0
                eyes[1].position = CGPoint(x: 0.0, y: 0.0)
                eyes[1].alpha = 0.0
                eyes[2].position = CGPoint(x: -distance, y: distance)
                eyes[2].alpha = 1.0
                eyes[3].position = CGPoint(x: distance, y: -distance)
                eyes[3].alpha = 1.0
                eyes[4].position = CGPoint(x: distance, y: 0.0)
                eyes[4].alpha = 0.0
                eyes[5].position = CGPoint(x: distance, y: distance)
                eyes[5].alpha = 1.0
            case 5:
                eyes[0].position = CGPoint(x: -distance, y: -distance)
                eyes[0].alpha = 1.0
                eyes[1].position = CGPoint(x: 0.0, y: 0.0)
                eyes[1].alpha = 1.0
                eyes[2].position = CGPoint(x: -distance, y: distance)
                eyes[2].alpha = 1.0
                eyes[3].position = CGPoint(x: distance, y: -distance)
                eyes[3].alpha = 1.0
                eyes[4].position = CGPoint(x: distance, y: 0.0)
                eyes[4].alpha = 0.0
                eyes[5].position = CGPoint(x: distance, y: distance)
                eyes[5].alpha = 1.0
            case 6:
                eyes[0].position = CGPoint(x: -distance, y: -distance)
                eyes[0].alpha = 1.0
                eyes[1].position = CGPoint(x: -distance, y: 0.0)
                eyes[1].alpha = 1.0
                eyes[2].position = CGPoint(x: -distance, y: distance)
                eyes[2].alpha = 1.0
                eyes[3].position = CGPoint(x: distance, y: -distance)
                eyes[3].alpha = 1.0
                eyes[4].position = CGPoint(x: distance, y: 0.0)
                eyes[4].alpha = 1.0
                eyes[5].position = CGPoint(x: distance, y: distance)
                eyes[5].alpha = 1.0
            default:
                break
        }
    }
    
    func render(duration:Double = 0.5) {
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
            return eyes[index]
        }
    }
}
