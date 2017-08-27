//
//  GradientView.swift
//  SocketIO Chat
//
//  Created by iulian david on 8/26/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {

    @IBInspectable var topColor = #colorLiteral(red: 0.3008218706, green: 0.3342579603, blue: 0.8641625047, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor = #colorLiteral(red: 0.03393415734, green: 0.8049962521, blue: 0.8281701803, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        let layoutGradient = CAGradientLayer()
        layoutGradient.colors = [topColor.cgColor, bottomColor.cgColor]
        layoutGradient.frame = self.bounds
        layoutGradient.startPoint = CGPoint(x: 0, y: 0)
        layoutGradient.endPoint = CGPoint(x: 1, y: 1)
        self.layer.insertSublayer(layoutGradient, at: 0)
        
    }

}
