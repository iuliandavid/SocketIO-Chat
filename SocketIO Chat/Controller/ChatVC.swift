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
    
    @IBOutlet weak var channelNameLbl: UILabel!
    
    //a button to appear when the menu is shown
    @IBOutlet weak var blurButton: UIButton!
    @IBOutlet weak var messageTxt: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    var menuShown = false
    
    //unwind segue
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    
    
    //objects
    let messageClient: MessageService = MessageServiceClient.instance
    let authClient: AuthService = AuthServiceClient.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardEvents()
        
        
        menuView.chatVC = self
        menuView.customViewWidth = menuViewLeadingConstraint
        blurButton.addTarget(self, action: #selector(handleShowMenu), for: .touchUpInside)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange(_:)), name: Constants.NOTIF_DATA_DID_CHANGE, object: nil)
        
        messageTxt.isHidden = true
        sendButton.isHidden = true
        // TODO - move outside controller
        if authClient.isLoggedIn {
            authClient.findUserByEmail(completion: { (success, err) in
                if success {
                    NotificationCenter.default.post(name: Constants.NOTIF_DATA_DID_CHANGE, object: nil)
                }
            })
        }
        // TODO - move outside controller
        messageClient.selectedChannel.bind { [unowned self] (selectedChanel) in
            self.channelNameLbl.text = "#\(selectedChanel?.channelTitle ?? "")"
            self.getMessages(channelId: selectedChanel?.id)
        }
        
        messageClient.messages.bindAndFire { (messageArray) in
            
        }
    }
    
    //MARK: - Actions
    @IBAction func menuPressed(_ sender: Any) {
        handleShowMenu()
    }
    
    @IBAction func sendMessgPressed(_ sender: UIButton) {
        guard let messageBody = messageTxt.text, messageBody != "",
            let channelId = messageClient.selectedChannel.value?.id else {
                return
        }
        
        messageClient.sendMessage(messageBody: messageBody, channelId: channelId) {[weak self] (success, err) in
            if success {
                self?.messageTxt.text = ""
                self?.messageTxt.resignFirstResponder()
            }
        }
    }
    
    
    @objc func userDataDidChange(_ notification: Notification) {
        menuView.userDataChanged()
        // TODO - move outside controller
        if authClient.isLoggedIn {
            //get channels
            onLoginMessages()
        } else {
            channelNameLbl.text = "Please Log In"
        }
        
        messageTxt.isHidden = !authClient.isLoggedIn
        sendButton.isHidden = !authClient.isLoggedIn
    }
    
    // TODO - move outside controller
    func onLoginMessages() {
        messageClient.findAllChannels { [unowned self] (success, error) in
            if success {
                if self.messageClient.channels.value.count > 0 {
                    self.messageClient.selectedChannel.value = self.messageClient.channels.value[0]
                } else {
                    self.channelNameLbl.text = "No channels yet"
                }
            }
        }
    }
    
    fileprivate func getMessages(channelId: String?) {
        guard let channelId = channelId else {
            return
        }
        messageClient.findAllMessages(forChannelId: channelId) { [weak self] (success, err) in
            self?.messageClient.getMessages()
        }
        
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

// MARK: - Keyboard Events show/dismiss
private extension ChatVC {
    
    func setupKeyboardEvents() {
        view.bindToKeyboard()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapForUnbindToKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTapForUnbindToKeyboard() {
        view.endEditing(true)
    }
}
