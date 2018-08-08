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
                divider.strokeColor = color
            }
        }
    }
    
    var screen: SKShapeNode!
    var divider: SKShapeNode!
    
    override init() {
        super.init()
        
        //top()
        //bottom()
        //left()
        //right()
        
        screenFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func screenFrame() {
        let w:CGFloat = UIScreen.main.bounds.width // 375
        let w2 = w / 2.0
        let h:CGFloat = UIScreen.main.bounds.height // 812
        let h2 = h / 2.0
        let n:CGFloat = 209 // notch
        let n2:CGFloat = n / 2.0
        let r:CGFloat = CORNER_RADIUS // 40
        let r2:CGFloat = 20
        let r3:CGFloat = 6
        let l: CGFloat = 5
        let l2: CGFloat = 5 / 2.0

        let screenPath = UIBezierPath()
        // https://www.paintcodeapp.com/news/iphone-x-screen-demystified
        screenPath.move(to: CGPoint(x: -w2, y: h2))
        screenPath.addLine(to: CGPoint(x: -w2, y: h2 - r))
        screenPath.addArc(withCenter: CGPoint(x: -w2 + r, y: h2 - r), radius: r, startAngle: .pi, endAngle: .pi/2, clockwise: false)
        screenPath.addLine(to: CGPoint(x: -n2 - r3, y: h2))
        screenPath.addArc(withCenter: CGPoint(x: -n2 - r3, y: h2 - r3), radius: r3, startAngle: .pi/2, endAngle: 0, clockwise: false)
        screenPath.addArc(withCenter: CGPoint(x: -n2 + r2, y: h2 - r2/2), radius: r2, startAngle: .pi, endAngle: -.pi/2, clockwise: true)
        screenPath.addLine(to: CGPoint(x: n2 - r2, y: h2 - 3*r2/2))
        screenPath.addArc(withCenter: CGPoint(x: n2 - r2, y: h2 - r2/2), radius: r2, startAngle: -.pi/2, endAngle: 0, clockwise: true)
        screenPath.addArc(withCenter: CGPoint(x: n2 + r3, y: h2 - r3), radius: r3, startAngle: .pi, endAngle: .pi/2, clockwise: false)
        screenPath.addLine(to: CGPoint(x: w2 - r, y: h2))
        screenPath.addArc(withCenter: CGPoint(x: w2 - r, y: h2 - r), radius: r, startAngle: .pi/2, endAngle: 0, clockwise: false)
        screenPath.addLine(to: CGPoint(x: w2, y: -h2 + r))
        screenPath.addArc(withCenter: CGPoint(x: w2 - r, y: -h2 + r), radius: r, startAngle: 0, endAngle: -.pi/2, clockwise: false)
        screenPath.addLine(to: CGPoint(x: -w2 + r, y: -h2))
        screenPath.addArc(withCenter: CGPoint(x: -w2 + r, y: -h2 + r), radius: r, startAngle: -.pi/2, endAngle: -.pi, clockwise: false)
        screenPath.addLine(to: CGPoint(x: -w2, y: h2))
        screen = SKShapeNode()
        screen.path = screenPath.cgPath
        screen.zPosition = 0.9
        screen.fillColor = .clear
        screen.strokeColor = .clear
        screen.lineWidth = l
        screen.glowWidth = 1
        screen.position = CGPoint(x: 0, y: 0)
        addChild(screen)

        let dividerPath = UIBezierPath()
        dividerPath.addArc(withCenter: CGPoint(x: -w2 + r, y: h2 - BAR_HEIGHT - r), radius: r, startAngle: .pi, endAngle: .pi/2, clockwise: false)
        dividerPath.addLine(to: CGPoint(x: -n2 - r3, y: h2 - BAR_HEIGHT))
        dividerPath.addArc(withCenter: CGPoint(x: w2 - r, y: h2 - BAR_HEIGHT - r), radius: r, startAngle: .pi/2, endAngle: 0, clockwise: false)
        divider = SKShapeNode()
        divider.path = dividerPath.cgPath
        divider.zPosition = 0.9
        divider.fillColor = .clear
        divider.strokeColor = .green
        divider.lineWidth = l2
        divider.glowWidth = 1
        divider.position = CGPoint(x: 0, y: 0)
        addChild(divider)
        
        position = CGPoint(x: 0, y: 0)
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
}
