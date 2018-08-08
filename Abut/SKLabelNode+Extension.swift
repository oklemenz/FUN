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
        
        guard let labelText = self.text else { return }
        
        let font = UIFont(name: self.fontName!, size: self.fontSize)
        
        let attributedString:NSMutableAttributedString
        if let labelAttributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        let attributes:[NSAttributedStringKey:Any] = [.strokeColor: color, .strokeWidth: -width, .font: font!]
        attributedString.addAttributes(attributes, range: NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}
