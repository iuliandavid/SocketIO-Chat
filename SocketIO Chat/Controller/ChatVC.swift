//
//  ChatVC.swift
//  SocketIO Chat
//
//  Created by iulian david on 8/26/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var mainViewTrailingConstant: NSLayoutConstraint!
    @IBOutlet weak var menuViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuView: MenuView!
    
    @IBOutlet weak var channelNameLbl: UILabel!
    
    //a button to appear when the menu is shown
    @IBOutlet weak var blurButton: UIButton!
    @IBOutlet weak var mainViewBlurButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var messageTxt: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTable: UITableView!
    @IBOutlet weak var typingUsersLbl: UILabel!
    
    var menuShown = false
    
    //unwind segue
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) { }
    
    //objects
    let messageClient: MessageService = MessageServiceClient.instance
    let authClient: AuthService = AuthServiceClient.sharedInstance
    var isTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardEvents()
        
        messageTable.dataSource = self
        messageTable.delegate = self
        
        messageTable.estimatedRowHeight = 80
        messageTable.rowHeight = UITableViewAutomaticDimension
        
        menuView.chatVC = self
        menuView.customViewWidth = menuViewLeadingConstraint
        blurButton.addTarget(self, action: #selector(handleShowMenu), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange(_:)), name: Constants.notifDataDidChange, object: nil)
        
        messageTxt.isHidden = true
        sendButton.isHidden = true
        // TODO - move outside controller
        if authClient.isLoggedIn {
            authClient.findUserByEmail(completion: { (success, _) in
                if success {
                    NotificationCenter.default.post(name: Constants.notifDataDidChange, object: nil)
                }
            })
        }
        // TODO - move outside controller
        messageClient.selectedChannel.bind { [unowned self] (selectedChanel) in
            self.channelNameLbl.text = "#\(selectedChanel?.channelTitle ?? "")"
            self.getMessages(channelId: selectedChanel?.channelId)
        }
        
        messageClient.messages.bindAndFire {[unowned self] (_) in
            self.lazyReloadTable()
        }
        
        messageClient.typingUsersText.bindAndFire { [unowned self](message) in
            self.typingUsersLbl.text = message
        }
    }
    
    // MARK: - Slow Table Reload
    ///Try to reload table slowly, especially when new data arrives fast
    var timer: Timer?
    fileprivate func lazyReloadTable() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.reloadChannelData), userInfo: nil, repeats: false)
    }
    
    @objc func reloadChannelData() {
        print("reloaded data")
        messageTable.reloadData()
        //scroll to last
        guard messageClient.messages.value.count > 0  else {
            return
        }
        let endIndex = IndexPath(row: messageClient.messages.value.count - 1,section: 0)
        messageTable.scrollToRow(at: endIndex, at: .bottom, animated: false)
    }
    // MARK: - Actions
    @IBAction func menuPressed(_ sender: Any) {
        handleShowMenu()
    }
    
    @IBAction func sendMessgPressed(_ sender: UIButton) {
        guard let messageBody = messageTxt.text, messageBody != "",
            let channelId = messageClient.selectedChannel.value?.channelId else {
                return
        }
        
        messageClient.sendMessage(messageBody: messageBody, channelId: channelId) {[weak self] (success, _) in
            if success {
                self?.messageTxt.text = ""
                self?.messageTxt.resignFirstResponder()
                self?.userTyping()
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
            messageClient.clearMessages()
            messageClient.setUserTyping(typing: false)
            channelNameLbl.text = "Please Log In"
        }
        messageTxt.text = ""
        messageTxt.isHidden = !authClient.isLoggedIn
        
    }
    
    // TODO - move outside controller
    func onLoginMessages() {
        messageClient.findAllChannels { [unowned self] (success, _) in
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
        messageClient.findAllMessages(forChannelId: channelId) { [weak self] (_, _) in
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
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
        UIView.animate(withDuration: 0.0) {
            self.mainViewBlurButton.alpha = 0.0
        }
    }
    
    fileprivate func userTyping() {
        let typingChanged = isTyping
        if messageTxt.text == "" {
            isTyping = false
            sendButton.isHidden = true
        } else {
            if !isTyping {
                sendButton.isHidden = false
            }
            isTyping = true
        }
        if typingChanged != isTyping {
            messageClient.setUserTyping(typing: isTyping)
        }
    }
    
    @IBAction func messageEditing(_ sender: Any) {
        userTyping()
    }
}

// MARK: - Slide Menu related methods
extension ChatVC {
    @objc func handleShowMenu() {
        if menuShown {
            blurButton.alpha = 0
            menuViewLeadingConstraint.constant = -310
            mainViewTrailingConstant.constant = 0
        } else {
            blurButton.alpha = 0.1
            menuViewLeadingConstraint.constant = 0
            mainViewTrailingConstant.constant = -310
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
    
    func bindToKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(UIView.keyboardWillChange(_:)),
            name: NSNotification.Name.UIKeyboardWillChangeFrame,
            object: nil)
    }
    
    @objc func keyboardWillChange(_ notification: NSNotification) {
        guard let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as? UInt,
            let curFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let targetFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        let deltaY = targetFrame.origin.y - curFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
            self.view.frame.origin.y += deltaY
            self.mainViewBlurButton.alpha = 0.1
        },completion: {(_) in
            self.view.layoutIfNeeded()
        })
    }
    func setupKeyboardEvents() {
        
        bindToKeyboard()
        
    }
    
    @objc func handleTapForUnbindToKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITableView delegate and datasource
extension ChatVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageClient.messages.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.messageCellIdentifier, for: indexPath) as? MessageCell else {
            return UITableViewCell()
        }
        let message = messageClient.messages.value[indexPath.row]
        cell.configureCell(for: message)
        
        return cell
    }
}

extension ChatVC: UITableViewDelegate {}
