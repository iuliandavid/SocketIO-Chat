//
//  CreateAccountVC.swift
//  SocketIO Chat
//
//  Created by iulian david on 8/27/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {
    // outlets
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segues.UNWIND, sender: nil)
    }
    @IBAction func createAccountPressed(_ sender: Any) {
        guard let email = emailTxtField.text, !email.isEmpty, let pass = passwordTxtField.text, !pass.isEmpty else {
            return
            
        }
        
        AuthServiceClient.sharedInstance.registerUser(email: email, password: pass) { (success, error) in
            if success {
                print("registered user!")
            } else {
                let alert = UIAlertController(title: "Error", message: error!, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func pickAvatarPressed(_ sender: Any) {
    }
    
    @IBAction func pickBGColorPressed(_ sender: Any) {
    }
    
    
}
