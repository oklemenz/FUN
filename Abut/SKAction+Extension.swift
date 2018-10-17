//
//  SKAction+Extension.swift
//  Abut
//
//  Created by Klemenz, Oliver on 17.10.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

extension SKAction {
    
    class func shake(initialPosition:CGPoint, duration:Float, completed: (() -> ())? = nil, amplitudeX:Int = 10, amplitudeY:Int = 5) -> SKAction {
        let startingX = initialPosition.x
        let startingY = initialPosition.y
        let numberOfShakes = duration / 0.015
        var actions: [SKAction] = []
        for _ in 1...Int(numberOfShakes) {
            let newXPos = startingX + CGFloat(arc4random_uniform(UInt32(amplitudeX))) - CGFloat(amplitudeX / 2)
            let newYPos = startingY + CGFloat(arc4random_uniform(UInt32(amplitudeY))) - CGFloat(amplitudeY / 2)
            actions.append(SKAction.move(to: CGPoint(x: newXPos, y: newYPos), duration: 0.015))
        }
        actions.append(SKAction.move(to: initialPosition, duration: 0.015))
        actions.append(SKAction.run {
            completed?()
        })
        return SKAction.sequence(actions)
    }
}
