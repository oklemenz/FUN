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

    static let boardTexture = SKTexture(size: UIScreen.main.bounds.width, color1: UIColor(rgba: "#666666"),
                                        color2: UIColor(rgba: "#000000"))
    
    var lineWidth: CGFloat = BORDER_LINE_WIDTH {
        didSet {
            rerender()
        }
    }
    
    var color: SKColor? {
        didSet {
            rerender()
        }
    }
    
    var notch: Bool = Device.IS_IPHONE_X
    var screen: SKShapeNode!
    var board: SKShapeNode!
    
    static var screenTextureMap: [SKColor: SKTexture] = [:]
    
    static func clearScreenTextures() {
        screenTextureMap.removeAll()
    }
    
    override init() {
        super.init()
        render()
    }
    
    init(notch: Bool) {
        super.init()
        self.notch = notch
        render()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func render() {
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
        let l:CGFloat = lineWidth
        let l2:CGFloat = l / 2.0
        let i:CGFloat = l2 // Indent

        var screenPath: UIBezierPath!
        if notch {
            // https://www.paintcodeapp.com/news/iphone-x-screen-demystified
            screenPath = UIBezierPath()
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
            screenPath.addLine(to: CGPoint(x: w2 - i, y: -h2 + r + i))
            screenPath.addArc(withCenter: CGPoint(x: w2 - r - i, y: -h2 + r + i), radius: r, startAngle: 0, endAngle: -.pi/2, clockwise: false)
            screenPath.addLine(to: CGPoint(x: -w2 + r + i, y: -h2 + i))
            screenPath.addArc(withCenter: CGPoint(x: -w2 + r + i, y: -h2 + r + i), radius: r, startAngle: -.pi/2, endAngle: -.pi, clockwise: false)
            screenPath.addLine(to: CGPoint(x: -w2 + i, y: h2 - r - i))
        } else {
            screenPath = UIBezierPath(roundedRect: CGRect(x: -w2 + i, y: -h2 + i, width: w - 2 * i, height: h - 2 * i), cornerRadius: CORNER_RADIUS)
        }
        if screen == nil {
            screen = SKShapeNode()
            addChild(screen)
        }
        screen.path = screenPath.cgPath
        screen.zPosition = 0.9
        screen.fillColor = .white
        screen.glowWidth = 1
        screen.position = CGPoint(x: 0, y: 0)
        
        if board == nil {
            board = SKShapeNode(rect: CGRect(x: -w2 + l2, y: -h2 + l2, width: w - l, height: h - l - BAR_HEIGHT), cornerRadius: r)
            addChild(board)
        }
        board.zPosition = 0.9
        board.fillColor = .white
        board.fillTexture = Border.boardTexture
        board.glowWidth = 1
        board.position = CGPoint(x: 0, y: 0)

        position = CGPoint(x: 0, y: 0)
        
        rerender()
    }
    
    func rerender() {
        let l:CGFloat = lineWidth
        board.lineWidth = l
        board.strokeColor = color ?? .clear
        
        var screenTexture = Border.screenTextureMap[color ?? .white]
        if screenTexture == nil {
            screenTexture = SKTexture(size: UIScreen.main.bounds.width, color1: color ?? .white, color2: UIColor(rgba: "#000000"))
            Border.screenTextureMap[color ?? .white] = screenTexture
        }
        screen.fillTexture = screenTexture
        screen.strokeColor = color ?? .clear
        screen.lineWidth = l
    }
}
