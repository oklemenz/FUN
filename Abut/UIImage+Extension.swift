//
//  UIImage+Extension.swift
//  Abut
//
//  Created by Klemenz, Oliver on 17.10.18.
//  Copyright © 2018 Klemenz, Oliver. All rights reserved.
//
import UIKit

extension UIImage {
    
    func tint(color: UIColor) -> UIImage {
        return modifiedImage { context, rect in
            context.setBlendMode(.normal)
            UIColor.black.setFill()
            context.fill(rect)
            context.setBlendMode(.normal)
            context.draw(self.cgImage!, in: rect)
            context.setBlendMode(.color)
            color.setFill()
            context.fill(rect)
            context.setBlendMode(.destinationIn)
            context.draw(self.cgImage!, in: rect)
        }
    }
    
    func fillAlpha(color: UIColor) -> UIImage {
        return modifiedImage { context, rect in
            context.setBlendMode(.normal)
            color.setFill()
            context.fill(rect)
            context.setBlendMode(.destinationIn)
            context.draw(self.cgImage!, in: rect)
        }
    }
    
    private func modifiedImage( draw: (CGContext, CGRect) -> ()) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context: CGContext! = UIGraphicsGetCurrentContext()
        assert(context != nil)
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        draw(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func colored(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.setFill()
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(.normal)
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
