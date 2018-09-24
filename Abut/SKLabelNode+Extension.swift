//
//  SKLabelNode+Extension.swift
//  Abut
//
//  Created by Klemenz, Oliver on 08.08.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

extension SKLabelNode {
    
    func addStroke(color: UIColor, width: CGFloat) {
        
        guard let labelText = self.text else {
            self.attributedText = nil
            return
        }
        guard labelText.count > 0 else {
            self.attributedText = nil
            return
        }
        
        let font = UIFont(name: self.fontName!, size: self.fontSize)
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: labelText)
        let attributes:[NSAttributedString.Key:Any] = [.strokeColor: color, .strokeWidth: -width, .font: font!]
        attributedString.addAttributes(attributes, range: NSMakeRange(0, attributedString.length))    
        self.attributedText = attributedString
    }
}
