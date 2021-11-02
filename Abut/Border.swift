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
    
    var lineThickness: CGFloat = BORDER_LINE_THICKNESS {
        didSet {
            rerender()
        }
    }
    
    var color: SKColor? {
        didSet {
            rerender()
        }
    }
    
    var notch: Bool = Device.IS_IPHONE && UIDevice.current.hasNotch
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
        let nw:CGFloat = UIDevice.current.notchWidth
        let n2:CGFloat = nw / 2.0
        let nh = UIDevice.current.notchHeight
        let r:CGFloat = UIDevice.current.cornerRadius
        let r2:CGFloat = UIDevice.current.notchRadius1
        let r3:CGFloat = UIDevice.current.notchRadius2
        let l:CGFloat = lineThickness
        let l2:CGFloat = l / 2.0
        let i:CGFloat = l2 // Indent

        var screenPath: UIBezierPath!
        // https://www.paintcodeapp.com/news/iphone-x-screen-demystified
        if notch {
            screenPath = UIBezierPath()
            
            let leftMiddle = CGPoint(x: -w2 + i, y: 0)
            screenPath.move(to: leftMiddle)

            let leftTopCorner = leftMiddle + CGPoint(x: 0, y: h2 - r - i)
            screenPath.addLine(to: leftTopCorner)
            let leftCornerCenter = leftTopCorner + CGPoint(x: r, y: 0);
            screenPath.addArc(withCenter: leftCornerCenter, radius: r, startAngle: .pi, endAngle: .pi/2, clockwise: false)
            
            let leftNotchCorner1 = CGPoint(x: -n2 - r3 - i, y: h2 - i)
            screenPath.addLine(to: leftNotchCorner1)
            let leftNotchTopCornerCenter1 = leftNotchCorner1 + CGPoint(x: 0, y: -r3)
            screenPath.addArc(withCenter: leftNotchTopCornerCenter1, radius: r3, startAngle: .pi/2, endAngle: 0, clockwise: false)
            
            let leftNotchCorner2 = CGPoint(x: -n2 - i, y: h2 - nh - i)
            let leftTopNotchCornerCenter2 = leftNotchCorner2 + CGPoint(x: r2, y: r2)
            screenPath.addArc(withCenter: leftTopNotchCornerCenter2, radius: r2, startAngle: .pi, endAngle: -.pi/2, clockwise: true)

            let rightNotchCorner2 = CGPoint(x: n2 - r2 + i, y: leftNotchCorner2.y)
            screenPath.addLine(to: rightNotchCorner2)
            let rightNotchCornerCenter2 = rightNotchCorner2 + CGPoint(x: 0, y: r2)
            screenPath.addArc(withCenter: rightNotchCornerCenter2, radius: r2, startAngle: -.pi/2, endAngle: 0, clockwise: true)
            
            let rightNotchCorner1 = CGPoint(x: n2 + i, y: leftNotchCorner1.y)
            let rightNotchCornerCenter1 = rightNotchCorner1 + CGPoint(x: r3, y: -r3)
            screenPath.addArc(withCenter: rightNotchCornerCenter1, radius: r3, startAngle: .pi, endAngle: .pi/2, clockwise: false)
            
            let rightTopCorner = CGPoint(x: w2 - r - i, y: h2 - i)
            screenPath.addLine(to: rightTopCorner)
            let rightCornerCenter = rightTopCorner + CGPoint(x: 0, y: -r)
            screenPath.addArc(withCenter: rightCornerCenter, radius: r, startAngle: .pi/2, endAngle: 0, clockwise: false)
            
            let rightBottomCorner = CGPoint(x: w2 - i, y: -h2 + r + i)
            screenPath.addLine(to: rightBottomCorner)
            let rightBottomCornerCenter = rightBottomCorner + CGPoint(x: -r, y: 0)
            screenPath.addArc(withCenter: rightBottomCornerCenter, radius: r, startAngle: 0, endAngle: -.pi/2, clockwise: false)
            
            let leftBottomCorner = CGPoint(x: -w2 + r + i, y: -h2 + i)
            screenPath.addLine(to: leftBottomCorner)
            let leftBottomCornerCenter = leftBottomCorner + CGPoint(x: 0, y: r)
            screenPath.addArc(withCenter: leftBottomCornerCenter, radius: r, startAngle: -.pi/2, endAngle: -.pi, clockwise: false)

            screenPath.addLine(to: leftMiddle)
        } else {
            screenPath = UIBezierPath(roundedRect: CGRect(x: -w2 + i, y: -h2 + i, width: w - 2 * i, height: h - 2 * i), cornerRadius: UIDevice.current.cornerRadius)
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
        let l:CGFloat = lineThickness
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
