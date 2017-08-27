//
//  MenuView.swift
//  SocketIO Chat
//
//  Created by iulian david on 8/26/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import UIKit

class MenuView: GradientView {

    var startPosition: CGPoint?
    var originalWidth: CGFloat = 0
    var customViewWidth: NSLayoutConstraint!

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        startPosition = touch?.location(in: self)
        originalWidth = customViewWidth.constant
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let endPosition = touch?.location(in: self)
        let difference = endPosition!.x - startPosition!.x
        customViewWidth.constant = originalWidth + difference
        UIView.animate(withDuration: 0.3) {
            self.layoutSubviews()
        }
    }

}
