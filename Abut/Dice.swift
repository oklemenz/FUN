//
//  Dice.swift
//  Abut
//
//  Created by Klemenz, Oliver on 19.07.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

class Dice : SKNode {
    
    let distance = 60
    
    var eyes: [DiceEye] = []
    var value = 0 {
        didSet {
            render()
        }
    }
    
    init(value: Int = 6) {
        super.init()
        for _ in 0..<6 {
            let eye = DiceEye()
            eyes.append(eye)
            addChild(eye)
        }
        self.value = value
        render()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func render() {
        for i in 0..<6 {
            eyes[i].isHidden = i >= value
        }
        switch value {
            case 1:
                eyes[0].position = CGPoint(x: 0, y: 0)
            case 2:
                eyes[0].position = CGPoint(x: -distance, y: -distance)
                eyes[1].position = CGPoint(x: distance, y: distance)
            case 3:
                eyes[0].position = CGPoint(x: 0, y: 0)
                eyes[1].position = CGPoint(x: -distance, y: -distance)
                eyes[2].position = CGPoint(x: distance, y: distance)
                break
            case 4:
                eyes[0].position = CGPoint(x: -distance, y: -distance)
                eyes[1].position = CGPoint(x: -distance, y: distance)
                eyes[2].position = CGPoint(x: distance, y: -distance)
                eyes[3].position = CGPoint(x: distance, y: distance)
                break
            case 5:
                eyes[0].position = CGPoint(x: 0, y: 0)
                eyes[1].position = CGPoint(x: -distance, y: -distance)
                eyes[2].position = CGPoint(x: -distance, y: distance)
                eyes[3].position = CGPoint(x: distance, y: -distance)
                eyes[4].position = CGPoint(x: distance, y: distance)
                break
            case 6:
                eyes[0].position = CGPoint(x: -distance, y: -distance)
                eyes[1].position = CGPoint(x: -distance, y: 0)
                eyes[2].position = CGPoint(x: -distance, y: distance)
                eyes[3].position = CGPoint(x: distance, y: -distance)
                eyes[4].position = CGPoint(x: distance, y: 0)
                eyes[5].position = CGPoint(x: distance, y: distance)
                break
            default:
                break
        }
    }
    
    subscript(index: Int) -> DiceEye {
        get {
            return eyes[index];
        }
    }
}
