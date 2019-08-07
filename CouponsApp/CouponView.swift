//
//  CouponView.swift
//  CouponView
//
//  Created by Sudhakar Reddy Mallidi on 04/08/19.
//  Copyright © 2019 Sudhakar Reddy. All rights reserved.
//

import UIKit
class CouponView : UIView {
    var ticketColor: UIColor = UIColor.white
    var circleDiameter: CGFloat = 30
    var cuttingDepth: CGFloat = 0
    var tearRight: Bool = true
    var tearLeft: Bool = true
    var circlePosition: CGFloat = 0.0
    init(frame: CGRect, circlePosition: CGFloat) {
        self.circlePosition = circlePosition - circleDiameter/2
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let lineSeparator:CGFloat = 1.0
    var lineHeight: CGFloat = 10
    let cuttingLength: CGFloat = 2
    // MARK:- UIView Draw method
    override func draw(_ rect: CGRect) {
        layer.sublayers = []
        drawTicket()
        drawDottedLine(start: CGPoint(x: 0 + circleDiameter/2 + 10, y: self.circlePosition), end: CGPoint(x: self.bounds.width - circleDiameter/2 - 10, y: self.circlePosition))
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    func drawTicket() {
        lineHeight = circleDiameter
        let ticketLayer = CAShapeLayer()
        ticketLayer.frame = bounds
        let ticketPath = UIBezierPath()
        let zero:CGFloat = 0.0
        let viewWidth = self.bounds.width - zero*2
        let viewHeight = self.bounds.height - zero*2
        ticketPath.move(to: CGPoint(x: zero, y: zero))
        //let numberOfCirclesHorizontally = 1//Int(viewWidth/(lineHeight+circleDiameter))
        //let extraLineHorizontally = (Int(viewWidth) - Int(circleDiameter)*numberOfCirclesHorizontally - Int(lineHeight)*(numberOfCirclesHorizontally-1))/2
        let numberOfCirclesVertically = 1//Int(viewHeight/(lineHeight+circleDiameter))
        let extraLineVertically = (viewHeight - circleDiameter*CGFloat(numberOfCirclesVertically) - (lineHeight)*CGFloat(numberOfCirclesVertically-1))/2
        // Left Properties
        var currentLineLeft: CGFloat = zero+lineSeparator
        var nextLineLeft: CGFloat = extraLineVertically
        // Bottom Properties
        //var currentLineBottom: CGFloat = zero+lineSeparator
        //var nextLineBottom: CGFloat = CGFloat(extraLineHorizontally)
        // Right Properties
        var currentLineRight: CGFloat = viewHeight-lineSeparator
        var nextLineRight: CGFloat = viewHeight - extraLineVertically
        // Top Properties
        //var currentLineTop: CGFloat = viewWidth
        //var nextLineTop: CGFloat = viewWidth - CGFloat(extraLineHorizontally)
        if tearLeft {
            for _ in 1...numberOfCirclesVertically {
                for j in stride(from: currentLineLeft, to: nextLineLeft, by: cuttingLength+lineSeparator) {
                    if j < (nextLineLeft-cuttingLength) {
                        ticketPath.addLine(to: CGPoint(x: zero, y: j))
                        ticketPath.addLine(to: CGPoint(x: zero+cuttingDepth, y: j))
                        ticketPath.addLine(to: CGPoint(x: zero+cuttingDepth, y: j+cuttingLength))
                        ticketPath.addLine(to: CGPoint(x: zero, y: j+cuttingLength))
                    }
                }
                // adding curve
                ticketPath.addArc(withCenter: CGPoint(x: zero, y: circlePosition),
                                  radius: circleDiameter/2,
                                  startAngle: CGFloat(270).toRadians(),
                                  endAngle: CGFloat(90).toRadians(),
                                  clockwise: true)
                
                currentLineLeft = nextLineLeft+circleDiameter+lineSeparator
                nextLineLeft += (lineHeight + circleDiameter)
            }
            // 3
            for j in stride(from: currentLineLeft, to: viewHeight, by: cuttingLength+lineSeparator) {
                if j < (viewHeight-cuttingLength) {
                    ticketPath.addLine(to: CGPoint(x: zero, y: j))
                    ticketPath.addLine(to: CGPoint(x: zero+cuttingDepth, y: j))
                    ticketPath.addLine(to: CGPoint(x: zero+cuttingDepth, y: j+cuttingLength))
                    ticketPath.addLine(to: CGPoint(x: zero, y: j+cuttingLength))
                }
            }
            ticketPath.addLine(to: CGPoint(x: zero, y: viewHeight))
        } else {
            ticketPath.addLine(to: CGPoint(x: zero, y: viewHeight))
        }
        //Bottom Line
        ticketPath.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        if tearRight {
            for _ in 1...numberOfCirclesVertically {
                // draw pattern till nextLineY
                for j in stride(from: currentLineRight, to: nextLineRight, by: -(cuttingLength+lineSeparator)) {
                    if j > (nextLineRight+cuttingLength) {
                        ticketPath.addLine(to: CGPoint(x: viewWidth, y: j))
                        ticketPath.addLine(to: CGPoint(x: viewWidth-cuttingDepth, y: j))
                        ticketPath.addLine(to: CGPoint(x: viewWidth-cuttingDepth, y: j-cuttingLength))
                        ticketPath.addLine(to: CGPoint(x: viewWidth, y: j-cuttingLength))
                    }
                }
                
                // adding curve
                ticketPath.addArc(withCenter: CGPoint(x: viewWidth, y: circlePosition),
                                  radius: circleDiameter/2,
                                  startAngle: CGFloat(90).toRadians(),
                                  endAngle: CGFloat(270).toRadians(),
                                  clockwise: true)
                
                currentLineRight = nextLineRight-circleDiameter-lineSeparator
                nextLineRight -= (lineHeight + circleDiameter)
            }
            // 3
            
            for j in stride(from: currentLineRight, to: zero, by: -(cuttingLength+lineSeparator)) {
                if j > (zero+cuttingLength) {
                    ticketPath.addLine(to: CGPoint(x: viewWidth, y: j))
                    ticketPath.addLine(to: CGPoint(x: viewWidth-cuttingDepth, y: j))
                    ticketPath.addLine(to: CGPoint(x: viewWidth-cuttingDepth, y: j-cuttingLength))
                    ticketPath.addLine(to: CGPoint(x: viewWidth, y: j-cuttingLength))
                }
            }
            ticketPath.addLine(to: CGPoint(x: viewWidth, y: zero))
        } else {
            ticketPath.addLine(to: CGPoint(x: viewWidth, y: zero))
        }
        ticketPath.close()
//        ticketPath.lineWidth = 2
//        ticketColor.setStroke()
//        ticketPath.stroke()
        ticketColor.setFill()
        ticketPath.fill()
        ticketLayer.path = ticketPath.cgPath
        ticketLayer.fillColor = ticketColor.cgColor
        layer.addSublayer(ticketLayer)
    }
}
extension CouponView {
    func drawDottedLine(start p0: CGPoint, end p1: CGPoint) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [5, 7] // 9 is the length of dash, 7 is length of the gap.
        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}
extension CGFloat {
    func toRadians() -> CGFloat {
        return self * .pi / 180.0
    }
}
