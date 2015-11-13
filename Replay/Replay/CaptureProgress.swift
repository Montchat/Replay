//
//  CaptureProgress.swift
//  Replay
//
//  Created by Joe E. on 11/12/15.
//  Copyright © 2015 Joe E. All rights reserved.
//

import UIKit

@IBDesignable class CaptureProgress: UIView {
    
    @IBInspectable var cornerRadius:CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
            
        }
        
    }
    
    @IBInspectable var borderWidth:CGFloat = 1 {
        didSet {
            layer.borderWidth = borderWidth
            
        }
        
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.CGColor
            
        }
        
    }
    
    @IBInspectable var strokeColor: UIColor? {
        didSet {
            
        }
        
    }
    
    
    override func drawRect(rect: CGRect) {

    }

}