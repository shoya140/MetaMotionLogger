//
//  SIGraphView.swift
//  MetaMotionLogger
//
//  Created by Shoya Ishimaru on 2019.04.17.
//  Copyright © 2019 shoya140. All rights reserved.
//

import UIKit

@IBDesignable class SIGraphView: UIView {
    @IBInspectable var maximumValue: Double = 1000.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var minimumValue: Double = -1000.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var minimumNumberOfValuesToBeDisplayed: UInt = 100 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var contentInset: UIEdgeInsets = .zero {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var gridColor = UIColor.systemGray.withAlphaComponent(0.3) {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var lineColor = UIColor.systemBlue {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var values: [Double]? {
        didSet {
            self.setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        // Calculate frame size
        var frame = bounds
        frame.origin.x += contentInset.left
        frame.origin.y += contentInset.bottom
        frame.size.width -= (contentInset.left + contentInset.right)
        frame.size.height -= (contentInset.top + contentInset.bottom)

        // Draw grid
        let numberOfHorizontalGrids: UInt = 5
        let horizontalGridMargin = (maximumValue - minimumValue) / Double(numberOfHorizontalGrids - 1)
        let verticalPixelPerValue: CGFloat = frame.height / CGFloat(maximumValue - minimumValue)

        let labelFont = UIFont.systemFont(ofSize: 8.0)
        let labelAttributes = [
            NSAttributedString.Key.foregroundColor: gridColor,
            NSAttributedString.Key.font: labelFont,
        ]

        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setLineWidth(1.0)

        for i in 0 ..< numberOfHorizontalGrids {
            let value: Double = minimumValue + horizontalGridMargin * Double(i)

            // Draw horizontal line
            var gridY: CGFloat = verticalPixelPerValue * CGFloat(value - minimumValue)
            if i == numberOfHorizontalGrids - 1 { gridY -= 1.0 }
            if i == 0 { gridY += 1.0 }

            context.move(to: CGPoint(x: 0, y: gridY))
            context.addLine(to: CGPoint(x: frame.width, y: gridY))

            // Draw label
            var labelY: CGFloat = frame.minY + verticalPixelPerValue * CGFloat(maximumValue - value)
            if i == 0 { labelY -= (labelFont.lineHeight + 1.0) }

            NSString(format: "%ld", Int(value)).draw(
                at: CGPoint(
                    x: frame.minX,
                    y: labelY
                ),
                withAttributes: labelAttributes
            )
        }

        context.setFillColor(gridColor.cgColor)
        context.strokePath()

        // Don't draw graph if values.count == 0
        if self.values == nil { return }
        let values = self.values!

        // Draw graph
        let path = UIBezierPath()
        path.lineWidth = 1.0

        let horizontalPixelPerValue: CGFloat = frame.width / CGFloat(max(1, max(Int(minimumNumberOfValuesToBeDisplayed) - 1, values.count - 1)))
        let offset = max(0, Int(minimumNumberOfValuesToBeDisplayed) - values.count)

        for (index, value) in values.enumerated() {
            let point = CGPoint(
                x: frame.minX + horizontalPixelPerValue * CGFloat(offset + index),
                y: frame.minY + verticalPixelPerValue * CGFloat(maximumValue - value)
            )

            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }

        lineColor.setStroke()
        path.stroke()
    }
}
