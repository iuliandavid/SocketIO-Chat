//
//  MenuView.swift
//  SocketIO Chat
//
//  Created by iulian david on 8/26/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import UIKit

class MenuView: UIView {
    
    //Outlets
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var channelTable: UITableView!
    //objects
    var startPosition: CGPoint?
    var originalWidth: CGFloat = 0
    var customViewWidth: NSLayoutConstraint! 
    
    private var channelViewModel = ChannelViewModel()
    
    
    var chatVC: ChatVC?
    
    var hasInit = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    //MenuView should have inherited GradientView
    //but Xcode fails compiling it
    fileprivate func fixDesignableStoryBoardFailure() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.3631127477, green: 0.4045833051, blue: 0.8775706887, alpha: 1).cgColor, #colorLiteral(red: 0.1725490196, green: 0.831372549, blue: 0.8470588235, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        fixDesignableStoryBoardFailure()
        
        if !hasInit {
            NotificationCenter.default.addObserver(self, selector: #selector(userDataChanged), name: Constants.NOTIF_DATA_DID_CHANGE, object: nil)
            
            channelTable.dataSource = self
            channelTable.delegate = self
            hasInit = true
            //Reacting to channel array updating
            channelViewModel.channels.bindAndFire(listener: { [unowned self](chanels) in
                self.lazyReloadTable()
            })
            channelViewModel.unreadChannels.bindAndFire(listener: {[unowned self] (_) in
                self.lazyReloadTable()
            })
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    @IBAction func addChannelPressed(_ sender: Any) {
        if channelViewModel.isLoggedIn() {
            // Show Add Channel View Controller
            let profile = AddChannelVC()
            profile.modalPresentationStyle = .custom
            chatVC?.present(profile, animated: true, completion: nil)
        } else {
            chatVC?.performSegue(withIdentifier: Constants.Segues.TO_LOGIN, sender: nil)
        }
        
    }
    
    // looks slugish
    //    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        let touch = touches.first
    //        let endPosition = touch?.location(in: self)
    //        let difference = endPosition!.x - startPosition!.x
    //        customViewWidth.constant = originalWidth + difference
    //        UIView.animate(withDuration: 0.3) {
    //            self.layoutSubviews()
    //        }
    //    }
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        let touch = touches.first
    //        startPosition = touch?.location(in: self)
    //        originalWidth = customViewWidth.constant
    //    }
    
    @objc func userDataChanged() {
        //wait for the data to be obtained
        channelViewModel.userDataChanged {[weak self] (loginTitle, imageName, bgColor) in
            self?.loginBtn.setTitle(loginTitle, for: .normal)
            self?.profileImage.image = UIImage(named: imageName)
            self?.profileImage.backgroundColor = bgColor
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
        channelTable.reloadData()
    }
}

extension MenuView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelViewModel.channels.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.CHANNEL_CELL_IDENTIFIER, for: indexPath) as? ChannelCell else {
            return ChannelCell()
        }
        
        let channel = channelViewModel.channels.value[indexPath.row]
        let hasUnreadMessages = channelViewModel.hasUnreadMessages(channel: channel)
        cell.configureCell(channel: channel, hasUnreadMessages: hasUnreadMessages)
        return cell
    }
}

extension MenuView: UITableViewDelegate {
    
    /// To get rid of
    /// [Warning] Warning once only: Detected a case where constraints ambiguously suggest a height of zero for a tableview cell's content view.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = channelViewModel.channels.value[indexPath.row]
        
        channelViewModel.selectedChannel = channel
        chatVC?.handleShowMenu()
    }
}
