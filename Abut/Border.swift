//
//  Border.swift
//  Abut
//
//  Created by Klemenz, Oliver on 30.07.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

class Border : SKNode {
    
    let WIDTH: CGFloat = 50
    let INSET: CGFloat = 5
    
    var color: SKColor? {
        didSet {
            if let color = color {
                screen.strokeColor = color
            }
        }
    }
    var screen: SKShapeNode!
    
    override init() {
        super.init()
        
        //top()
        //bottom()
        //left()
        //right()
        
        screenFrame()
    }

    func screenFrame() {
        let w:CGFloat = UIScreen.main.bounds.width
        let w2 = w / 2.0
        let h:CGFloat = UIScreen.main.bounds.height
        let h2 = h / 2.0
        
        screen = SKShapeNode()
        
        // https://www.paintcodeapp.com/news/iphone-x-screen-demystified
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: -w2, y: 0))
        bezierPath.addLine(to: CGPoint(x: -w2, y: h2 - 40))
        bezierPath.addArc(withCenter: CGPoint(x: -w2 + 40, y: h2 - 40), radius: 40, startAngle: .pi, endAngle: .pi/2, clockwise: false)
        bezierPath.addLine(to: CGPoint(x: -w2 + 77, y: h2))
        bezierPath.addArc(withCenter: CGPoint(x: -w2 + 77, y: h2 - 6), radius: 6, startAngle: .pi/2, endAngle: 0, clockwise: false)
        bezierPath.addArc(withCenter: CGPoint(x: -w2 + 103, y: h2 - 10), radius: 20, startAngle: .pi, endAngle: -.pi/2, clockwise: true)
        bezierPath.addLine(to: CGPoint(x: w2 - 103, y: h2 - 30))
        bezierPath.addArc(withCenter: CGPoint(x: w2 - 103, y: h2 - 10), radius: 20, startAngle: -.pi/2, endAngle: 0, clockwise: true)
        bezierPath.addArc(withCenter: CGPoint(x: w2 - 77, y: h2 - 6), radius: 6, startAngle: .pi, endAngle: .pi/2, clockwise: false)
        bezierPath.addLine(to: CGPoint(x: w2 - 40, y: h2))
        bezierPath.addArc(withCenter: CGPoint(x: w2 - 40, y: h2 - 40), radius: 40, startAngle: .pi/2, endAngle: 0, clockwise: false)
        bezierPath.addLine(to: CGPoint(x: w2, y: -h2 + 40))
        bezierPath.addArc(withCenter: CGPoint(x: w2 - 40, y: -h2 + 40), radius: 40, startAngle: 0, endAngle: -.pi/2, clockwise: false)
        bezierPath.addLine(to: CGPoint(x: -w2 + 40, y: -h2))
        bezierPath.addArc(withCenter: CGPoint(x: -w2 + 40, y: -h2 + 40), radius: 40, startAngle: -.pi/2, endAngle: -.pi, clockwise: false)
        bezierPath.addLine(to: CGPoint(x: -w2, y: 0))
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: bezierPath.cgPath)
        physicsBody?.isDynamic = false
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.collisionBitMask = CollisionCategoryDefault
        position = CGPoint(x: 0, y: 0)

        screen.path = bezierPath.cgPath
        screen.zPosition = 0.9
        screen.fillColor = .clear
        screen.strokeColor = .red // color ?? .clear
        screen.lineWidth = 5
        screen.glowWidth = 1
        screen.position = CGPoint(x: 0, y: 0)
        addChild(screen)

        /*box = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        box.zPosition = 999
        box.fillColor = .clear
        box.strokeColor = color ?? .clear
        box.lineWidth = INSET
        box.position = CGPoint(x: 0, y: 0)
        addChild(box)*/
        
        alpha = 0.75
    }
    
    func top() {
        let size = CGSize(width: UIScreen.main.bounds.width + 2 * WIDTH, height: WIDTH)
        let top = SKShapeNode(rectOf: size)
        top.zPosition = 0.1
        top.fillColor = .clear
        top.strokeColor = .clear
        top.physicsBody = SKPhysicsBody(rectangleOf: size)
        top.physicsBody?.isDynamic = false
        top.physicsBody?.usesPreciseCollisionDetection = true
        top.position = CGPoint(x: 0, y: (UIScreen.main.bounds.height + WIDTH) / 2.0)
        addChild(top)
    }
    
    func bottom() {
        let size = CGSize(width: UIScreen.main.bounds.width + 2 * WIDTH, height: WIDTH)
        let bottom = SKShapeNode(rectOf: size)
        bottom.zPosition = 0.1
        bottom.fillColor = .clear
        bottom.strokeColor = .clear
        bottom.physicsBody = SKPhysicsBody(rectangleOf: size)
        bottom.physicsBody?.isDynamic = false
        bottom.physicsBody?.usesPreciseCollisionDetection = true
        bottom.position = CGPoint(x: 0, y: -(UIScreen.main.bounds.height + WIDTH) / 2.0)
        addChild(bottom)
    }
    
    func left() {
        let size = CGSize(width: WIDTH, height: UIScreen.main.bounds.height + 2 * WIDTH)
        let left = SKShapeNode(rectOf: size)
        left.zPosition = 0.1
        left.fillColor = .red
        left.strokeColor = .clear
        left.physicsBody = SKPhysicsBody(rectangleOf: size)
        left.physicsBody?.isDynamic = false
        left.physicsBody?.usesPreciseCollisionDetection = true
        left.position = CGPoint(x: -(UIScreen.main.bounds.width + WIDTH) / 2.0, y: 0)
        addChild(left)
    }
    
    func right() {
        let size = CGSize(width: WIDTH, height: UIScreen.main.bounds.height + 2 * WIDTH)
        let right = SKShapeNode(rectOf: size)
        right.zPosition = 0.1
        right.fillColor = .red
        right.strokeColor = .clear
        right.physicsBody = SKPhysicsBody(rectangleOf: size)
        right.physicsBody?.isDynamic = false
        right.physicsBody?.usesPreciseCollisionDetection = true
        right.position = CGPoint(x: (UIScreen.main.bounds.width + WIDTH) / 2.0, y: 0)
        addChild(right)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
