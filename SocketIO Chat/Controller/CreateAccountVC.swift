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
    
    @IBOutlet weak var spinner : UIActivityIndicatorView!
    @IBOutlet weak var blurButton: UIButton!
    //objects
    private let viewModel = CreateAccountViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTxtField.delegate = self
        emailTxtField.delegate = self
        passwordTxtField.delegate = self
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        userImg.image = UIImage(named: viewModel.avatarName)
        userImg.backgroundColor = viewModel.getBackgroundColor()
        
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segues.UNWIND, sender: nil)
    }
    
    
    @IBAction func createAccountPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.blurButton.alpha = 0.2
            self?.spinner.startAnimating()
        }
        
        viewModel.registerUser { [weak self] (success, error) in
            UIView.animate(withDuration: 0.3, animations: {
                self?.blurButton.alpha = 0
                self?.spinner.stopAnimating()
            })
            if success {
                self?.performSegue(withIdentifier: Constants.Segues.UNWIND, sender: nil)
            } else {
                let errMessage = error!
                self?.showErrorMessage(errMessage)
            }
        }
    }
    
    @IBAction func pickAvatarPressed(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segues.TO_AVATAR_PICKER, sender: nil)
    }
    
    @IBAction func pickBGColorPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.userImg.backgroundColor = self?.viewModel.generateRandomColor()
        }
        
    }
    
    
    fileprivate func showErrorMessage(_ errMessage: String) {
        let alert = UIAlertController(title: "Error", message: errMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension CreateAccountVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else {
            return true
        }
        if textField == usernameTxtField {
            viewModel.updateUser(newValue: newString)
        } else if textField == passwordTxtField {
            viewModel.updatePassword(newValue: newString)
        } else if textField == emailTxtField {
            viewModel.updateEmail(newValue: newString)
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func setupView() {
        usernameTxtField.attributedPlaceholder = "username".getCustomAttributedText()
        passwordTxtField.attributedPlaceholder = "password".getCustomAttributedText()
        emailTxtField.attributedPlaceholder = getAttributtedText(text: "email")
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
}

//UI finest
extension CreateAccountVC {
    
    // first case
    private func getAttributtedText(text: String, foregroundColor: UIColor? = Constants.textPlaceholderColor) -> NSAttributedString {
        let attrs = [NSAttributedStringKey.foregroundColor: foregroundColor as Any] as [NSAttributedStringKey : Any]
        return NSAttributedString(string: text, attributes: attrs)
    }
}

