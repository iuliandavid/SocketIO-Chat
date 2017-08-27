//
//  ChatVC.swift
//  SocketIO Chat
//
//  Created by iulian david on 8/26/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var menuViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuView: MenuView!
    
    //a button to appear when the menu is shown
    @IBOutlet weak var blurButton: UIButton!
    var menuShown = false
    
    @IBOutlet weak var loginBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuView.customViewWidth = menuViewLeadingConstraint
        blurButton.addTarget(self, action: #selector(handleShowMenu), for: .touchUpInside)
    }
    
    //MARK: - Actions
    @IBAction func menuPressed(_ sender: Any) {
        handleShowMenu()
    }
    
    @IBAction func btnLoginPressed(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segues.TO_LOGIN, sender: nil)
    }
    
}

//MARK: - Slide Menu related methods
extension ChatVC {
    @objc func handleShowMenu() {
        if menuShown {
            blurButton.alpha = 0
            menuViewLeadingConstraint.constant = -280
            
        } else {
            blurButton.alpha = 0.1
            menuViewLeadingConstraint.constant = 0
            menuView.layer.shadowOpacity = 1
            menuView.layer.shadowOpacity = 10
        }
        animateLayout()
    }
    
    fileprivate func animateLayout() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        menuShown = !menuShown
    }
}
