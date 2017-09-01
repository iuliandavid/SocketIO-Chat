//
//  RoundedButton.swift
//  SocketIO Chat
//
//  Created by iulian david on 8/29/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
          setupView()
        }
    }

    
    override func draw(_ rect: CGRect) {
        setupView()
    }
    
    
    private func setupView() {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
}
