//
//  SIGraphView.swift
//  MetaMotionLogger
//
//  Created by Shoya Ishimaru on 2019.04.17.
//  Copyright © 2019 shoya140. All rights reserved.
//

import UIKit

@IBDesignable class SIGraphView: UIView {
    @IBInspectable var maximumValue: Double = 1000.0{
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var minimumValue: Double = -1000.0{
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var minimumNumberOfValuesToBeDisplayed: UInt = 200{
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var contentInset: UIEdgeInsets = UIEdgeInsets.zero{
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var gridColor: UIColor = UIColor(white: (219.0 / 255.0), alpha: 1.0){
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineColor: UIColor = UIColor.blue{
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var signals: [[Double]]?{
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Calculate frame size
        var frame = self.bounds
        frame.origin.x += self.contentInset.left
        frame.origin.y += self.contentInset.bottom
        frame.size.width -= (self.contentInset.left + self.contentInset.right)
        frame.size.height -= (self.contentInset.top + self.contentInset.bottom)
        
        // Draw background
        self.backgroundColor = UIColor.white
        
        // Draw grid
        let numberOfHorizontalGrids: UInt = 5
        let horizontalGridMargin = (self.maximumValue - self.minimumValue) / Double(numberOfHorizontalGrids - 1)
        let verticalPixelPerValue: CGFloat = frame.height / CGFloat(self.maximumValue - self.minimumValue)
        
        let labelFont = UIFont.systemFont(ofSize: 8.0)
        let labelAttributes = [
            NSAttributedString.Key.foregroundColor: self.gridColor,
            NSAttributedString.Key.font: labelFont
        ]
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setLineWidth(1.0)
        
        for i in 0..<numberOfHorizontalGrids {
            let value: Double = self.minimumValue + horizontalGridMargin * Double(i)
            
            // Draw horizontal line
            var gridY: CGFloat = verticalPixelPerValue * CGFloat(value - self.minimumValue)
            if i == numberOfHorizontalGrids - 1 { gridY -= 1.0 }
            if i == 0 { gridY += 1.0 }
            
            context.move(to: CGPoint(x: 0, y: gridY))
            context.addLine(to: CGPoint(x: frame.width, y: gridY))
            
            // Draw label
            var labelY: CGFloat = frame.minY + verticalPixelPerValue * CGFloat(self.maximumValue - value)
            if i == 0 {labelY -= (labelFont.lineHeight + 1.0) }
            
            NSString(format: "%ld", Int(value)).draw(
                at: CGPoint(
                    x: frame.minX,
                    y: labelY
                ),
                withAttributes: labelAttributes
            )
        }
        
        context.setFillColor(self.gridColor.cgColor)
        context.strokePath()
        
        // Don't draw graph if values.count == 0
        if self.signals == nil { return }
        
        for (index, values) in self.signals!.enumerated() {
            // Draw graph
            let path = UIBezierPath()
            path.lineWidth = 1.0
            
            let horizontalPixelPerValue: CGFloat = frame.width / CGFloat(max(1, max(Int(self.minimumNumberOfValuesToBeDisplayed) - 1, values.count - 1)))
            let offset = max(0, Int(self.minimumNumberOfValuesToBeDisplayed) - values.count)
            
            for (index, value) in values.enumerated() {
                let point = CGPoint(
                    x: frame.minX + horizontalPixelPerValue * CGFloat(offset + index),
                    y: frame.minY + verticalPixelPerValue * CGFloat(self.maximumValue - value)
                )
                
                if index == 0 {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
            }
            
            self.lineColor.darker(by: CGFloat(index*10))?.setStroke()
            path.stroke()
        }
    }
}
