//
//  ProfileVC.swift
//  SocketIO Chat
//
//  Created by iulian david on 9/1/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    private let userDataService = UserDataService.instance
    
    fileprivate func setupView() {
        profileImg.image = UIImage(named: userDataService.avatarName)
        profileImg.backgroundColor = userDataService.returnUIColor(components: userDataService.avatarColor)
        usernameLbl.text = userDataService.name
        emailLbl.text = userDataService.email
        
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        backgroundView.addGestureRecognizer(closeTap)
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    @IBAction func logoutPressed(_ sender: Any) {
        userDataService.logoutUser()
        NotificationCenter.default.post(name: Constants.notifDataDidChange, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
