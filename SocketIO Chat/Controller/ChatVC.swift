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
    
    //unwind segue
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuView.chatVC = self
        menuView.customViewWidth = menuViewLeadingConstraint
        blurButton.addTarget(self, action: #selector(handleShowMenu), for: .touchUpInside)
        if AuthServiceClient.sharedInstance.isLoggedIn {
            AuthServiceClient.sharedInstance.findUserByEmail(completion: { (success, err) in
                if success {
                    NotificationCenter.default.post(name: Constants.NOTIF_DATA_DID_CHANGE, object: nil)
                }
            })
        }
    }
    
    //MARK: - Actions
    @IBAction func menuPressed(_ sender: Any) {
        handleShowMenu()
    }
    
    
    @objc func userDataDidChange(_ notification: Notification) {
        menuView.userDataChanged()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        print("Deinit ChatVC")
        NotificationCenter.default.removeObserver(self)
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
            menuView.userDataChanged()
        }
        animateLayout()
    }
    
    fileprivate func animateLayout() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
        menuShown = !menuShown
    }
}
