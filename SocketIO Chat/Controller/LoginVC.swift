//
//  LoginVC.swift
//  SocketIO Chat
//
//  Created by iulian david on 8/27/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    //outlets
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccount(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segues.TO_CREATE_ACCOUNT, sender: nil)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        //!Since we are using a keyboard listener
        //we are force to set editing end
        view.endEditing(true)
        //!
        spinner.isHidden = false
        spinner.startAnimating()
        
        guard let email = emailTxt.text, emailTxt.text != "",
            let password = passwordTxt.text, passwordTxt.text != "" else {
                return
        }
        
        AuthServiceClient.sharedInstance.loginUser(email: email, password: password, completion: { (success, error) in
            if success {
                AuthServiceClient.sharedInstance.findUserByEmail(completion: { (success, err) in
                    if success {
                        NotificationCenter.default.post(name: Constants.NOTIF_DATA_DID_CHANGE, object: nil)
                        self.spinner.stopAnimating()
                        self.dismiss(animated: false, completion: nil)
                    }
                })
                
            }
        })
    }
    
    
    func setupView() {
        spinner.isHidden = true
        emailTxt.attributedPlaceholder = "email".getCustomAttributedText()
        passwordTxt.attributedPlaceholder = "password".getCustomAttributedText()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
}
