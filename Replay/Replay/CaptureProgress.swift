//
//  CaptureProgress.swift
//  Replay
//
//  Created by Joe E. on 11/12/15.
//  Copyright © 2015 Joe E. All rights reserved.
//

import UIKit

@IBDesignable class CaptureProgress: UIView {
    
    @IBInspectable var progressAmount:CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable var progressColor:UIColor = UIColor.redColor().colorWithAlphaComponent(0.50) {
        didSet { setNeedsDisplay() }
        
    }
    
    @IBInspectable var cornerRadius:CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
            
        }
        
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineWidth(context, 3)
        CGContextSetLineCap(context, .Round)
        
        UIColor(white: 0, alpha: 0.25).set()
        
        CGContextStrokeEllipseInRect(context, CGRectInset(rect, 20, 20))
        
        progressColor.set()
        
//        CGContextFillEllipseInRect(context, CGRect(x: 0, y: 0, width: 30, height: 30))
        
        //progress circle 
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = rect.width / 2 - 20
        
        let startAngle = -CGFloat(M_PI * 2 * 0.25)
        let progressAngle = CGFloat(M_PI * 2) * (progressAmount / 100) + startAngle
        
        let progressPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: progressAngle, clockwise: true)
        
        CGContextAddPath(context, progressPath.CGPath)
        
        CGContextStrokePath(context)

    }

}