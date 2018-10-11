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
    
    let BLOCK: CGFloat = 100
    let INSET: CGFloat = 5
    
    var color: SKColor? {
        didSet {
            if let color = color {
                screen.strokeColor = color
                board.strokeColor = color
                screen.fillTexture = SKTexture(size: UIScreen.main.bounds.width, color1: CIColor(color: color), color2: CIColor(rgba: "#000000"))
            }
        }
    }
    
    var screen: SKShapeNode!
    var board: SKShapeNode!
    
    override init() {
        super.init()
        background()
        top()
        bottom()
        left()
        right()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func background() {
        let w = UIScreen.main.bounds.width
        let w2 = w / 2.0
        let h = UIScreen.main.bounds.height
        let h2 = h / 2.0
        let n = NOTCH_WIDTH
        let n2:CGFloat = n / 2.0
        let nh = NOTCH_HEIGHT
        let r:CGFloat = CORNER_RADIUS
        let r2:CGFloat = NOTCH_RADIUS_1
        let r3:CGFloat = NOTCH_RADIUS_2
        let l:CGFloat = BORDER_LINE_WIDTH
        let l2:CGFloat = l / 2.0
        let i:CGFloat = l2 // Indent

        var screenPath: UIBezierPath!
        if Device.IS_IPHONE_X {
            // https://www.paintcodeapp.com/news/iphone-x-screen-demystified
            screenPath = UIBezierPath()
            screenPath.move(to: CGPoint(x: -w2 + i, y: h2))
            screenPath.addLine(to: CGPoint(x: -w2 + i, y: h2 - r - i))
            screenPath.addArc(withCenter: CGPoint(x: -w2 + r + i, y: h2 - r - i), radius: r, startAngle: .pi, endAngle: .pi/2, clockwise: false)
            screenPath.addLine(to: CGPoint(x: -n2 - r3 - i, y: h2 - i))
            screenPath.addArc(withCenter: CGPoint(x: -n2 - r3 - i, y: h2 - r3 - i), radius: r3, startAngle: .pi/2, endAngle: 0, clockwise: false)
            screenPath.addArc(withCenter: CGPoint(x: -n2 + r2 - i, y: h2 - nh + r2 - i), radius: r2, startAngle: .pi, endAngle: -.pi/2, clockwise: true)
            screenPath.addLine(to: CGPoint(x: n2 - r2 - i, y: h2 - nh - i))
            screenPath.addArc(withCenter: CGPoint(x: n2 - r2 + i, y: h2 - nh + r2 - i), radius: r2, startAngle: -.pi/2, endAngle: 0, clockwise: true)
            screenPath.addArc(withCenter: CGPoint(x: n2 + r3 + i, y: h2 - r3 - i), radius: r3, startAngle: .pi, endAngle: .pi/2, clockwise: false)
            screenPath.addLine(to: CGPoint(x: w2 - r - i, y: h2 - i))
            screenPath.addArc(withCenter: CGPoint(x: w2 - r - i, y: h2 - r - i), radius: r, startAngle: .pi/2, endAngle: 0, clockwise: false)
            screenPath.addLine(to: CGPoint(x: w2 - i, y: -h2 + r - i))
            screenPath.addArc(withCenter: CGPoint(x: w2 - r - i, y: -h2 + r - i), radius: r, startAngle: 0, endAngle: -.pi/2, clockwise: false)
            screenPath.addLine(to: CGPoint(x: -w2 + r + i, y: -h2 + i))
            screenPath.addArc(withCenter: CGPoint(x: -w2 + r + i, y: -h2 + r + i), radius: r, startAngle: -.pi/2, endAngle: -.pi, clockwise: false)
            screenPath.addLine(to: CGPoint(x: -w2 + i, y: h2))
        } else {
            screenPath = UIBezierPath(roundedRect: CGRect(x: -w2 + i, y: -h2 + i, width: w - 2 * i, height: h - 2 * i), cornerRadius: CORNER_RADIUS)
        }
        screen = SKShapeNode()
        screen.path = screenPath.cgPath
        screen.zPosition = 0.9
        screen.fillColor = .white
        screen.strokeColor = .clear
        screen.lineWidth = l
        screen.glowWidth = 1
        screen.position = CGPoint(x: 0, y: 0)
        addChild(screen)
        
        board = SKShapeNode(rect: CGRect(x: -w2 + l2, y: -h2 + l2, width: w - l, height: h - l - BAR_HEIGHT), cornerRadius: r)
        board.zPosition = 0.9
        board.fillColor = .white
        board.fillTexture = SKTexture(size: UIScreen.main.bounds.width, color1: CIColor(rgba: "#666666"), color2: CIColor(rgba: "#000000"))
        board.strokeColor = .clear
        board.lineWidth = l
        board.glowWidth = 1
        board.position = CGPoint(x: 0, y: 0)
        addChild(board)

        color = Ball.colorForValue(1)
        position = CGPoint(x: 0, y: 0)
    }
    
    func top() {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let h2 = h / 2.0
        let size = CGSize(width: w + 2 * BLOCK, height: BLOCK)
        let top = SKShapeNode(rectOf: size)
        top.zPosition = 0.1
        top.fillColor = .clear
        top.strokeColor = .clear
        top.physicsBody = SKPhysicsBody(rectangleOf: size)
        top.physicsBody?.isDynamic = false
        top.physicsBody?.usesPreciseCollisionDetection = true
        top.position = CGPoint(x: 0, y: h2 + BLOCK/2 + INSET - BAR_HEIGHT)
        addChild(top)
    }
    
    func bottom() {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let h2 = h / 2.0
        let size = CGSize(width: w + 2 * BLOCK, height: BLOCK)
        let bottom = SKShapeNode(rectOf: size)
        bottom.zPosition = 0.1
        bottom.fillColor = .clear
        bottom.strokeColor = .clear
        bottom.physicsBody = SKPhysicsBody(rectangleOf: size)
        bottom.physicsBody?.isDynamic = false
        bottom.physicsBody?.usesPreciseCollisionDetection = true
        bottom.position = CGPoint(x: 0, y: -h2 - BLOCK/2 - INSET)
        addChild(bottom)
    }
    
    func left() {
        let w = UIScreen.main.bounds.width
        let w2 = w / 2.0
        let h = UIScreen.main.bounds.height
        let size = CGSize(width: BLOCK, height: h + 2 * BLOCK)
        let left = SKShapeNode(rectOf: size)
        left.zPosition = 0.1
        left.fillColor = .clear
        left.strokeColor = .clear
        left.physicsBody = SKPhysicsBody(rectangleOf: size)
        left.physicsBody?.isDynamic = false
        left.physicsBody?.usesPreciseCollisionDetection = true
        left.position = CGPoint(x: -w2 - BLOCK/2 - INSET, y: 0)
        addChild(left)
    }
    
    func right() {
        let w = UIScreen.main.bounds.width
        let w2 = w / 2.0
        let h = UIScreen.main.bounds.height
        let size = CGSize(width: BLOCK, height: h + 2 * BLOCK)
        let right = SKShapeNode(rectOf: size)
        right.zPosition = 0.1
        right.fillColor = .clear
        right.strokeColor = .clear
        right.physicsBody = SKPhysicsBody(rectangleOf: size)
        right.physicsBody?.isDynamic = false
        right.physicsBody?.usesPreciseCollisionDetection = true
        right.position = CGPoint(x: w2 + BLOCK/2 + INSET, y: 0)
        addChild(right)
    }
}
