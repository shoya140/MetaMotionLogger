//
//  SIFlatButton.swift
//  MetaMotionLogger
//
//  Created by Shoya Ishimaru on 2019.04.17.
//  Copyright © 2019 shoya140. All rights reserved.
//

import UIKit

@IBDesignable class SIFlatButton: UIButton {
    
    @IBInspectable var inverse: Bool = false {
        didSet {
            updateButtonColor()
        }
    }
    
    @IBInspectable var buttonColor: UIColor = UIColor.blue {
        didSet {
            updateButtonColor()
        }
    }
    
    func updateButtonColor() {
        if inverse {
            setTitleColor(UIColor.white, for: [])
            setTitleColor(buttonColor, for: .highlighted)
            backgroundColor = buttonColor
        } else {
            setTitleColor(buttonColor, for: [])
            setTitleColor(UIColor.white, for: .highlighted)
            backgroundColor = UIColor.clear
        }
        
        setTitleShadowColor(UIColor.clear, for: [])
        setTitleShadowColor(UIColor.clear, for: .highlighted)
        layer.borderColor = buttonColor.cgColor
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                if inverse {
                    backgroundColor = UIColor.clear
                } else {
                    backgroundColor = buttonColor
                }
            } else {
                if inverse {
                    backgroundColor = buttonColor
                } else {
                    backgroundColor = UIColor.clear
                }
            }
        }
    }
    
}
