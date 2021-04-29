//
//  CircleThumbnailView.swift
//  Trallet
//
//  Created by Nicholas on 29/04/21.
//

import UIKit

class CircleThumbnailView: UIView {
    
    func angleToRadian(angle: CGFloat) -> CGFloat {
        return angle * .pi / 100.0
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        
        let cLayer = CAShapeLayer()
        
        cLayer.frame = bounds
        
        let radius = min(bounds.width, bounds.height) / 2.0
        let centerPoint = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
        
        let path = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: angleToRadian(angle: 0.0), endAngle: angleToRadian(angle: 360.0), clockwise: true)
        
        cLayer.path = path.cgPath
        layer.mask = cLayer
    }

}
