//
//  MenuView.swift
//  SocketIO Chat
//
//  Created by iulian david on 8/26/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import UIKit

class MenuView: GradientView {

    //Outlets
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    //objects
    var startPosition: CGPoint?
    var originalWidth: CGFloat = 0
    var customViewWidth: NSLayoutConstraint! 

    private var channelViewModel = ChannelViewModel()
    
    var chatVC: ChatVC?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(userDataChanged), name: Constants.NOTIF_DATA_DID_CHANGE, object: nil)
        
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        startPosition = touch?.location(in: self)
        originalWidth = customViewWidth.constant
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if channelViewModel.isLoggedIn() {
            // Show Profile Page
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            chatVC?.present(profile, animated: true, completion: nil)
        } else {
            chatVC?.performSegue(withIdentifier: Constants.Segues.TO_LOGIN, sender: nil)
        }
       
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
    
    @objc func userDataChanged() {
        channelViewModel.userDataChanged()
        loginBtn.setTitle(channelViewModel.loginTitle, for: .normal)
        profileImage.image = UIImage(named: channelViewModel.imageName)
        profileImage.backgroundColor = channelViewModel.bgColor
    }
}
