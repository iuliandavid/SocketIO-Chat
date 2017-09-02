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

    override func layoutSubviews() {
        if !hasInit {
            NotificationCenter.default.addObserver(self, selector: #selector(userDataChanged), name: Constants.NOTIF_DATA_DID_CHANGE, object: nil)
            channelTable.dataSource = self
            channelTable.delegate = self
            hasInit = true
            channelViewModel.channels.bindAndFire(listener: { [unowned self](chanels) in
                self.channelTable.reloadData()
            })
        }
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
        //wait for the data to be obtained
        channelViewModel.userDataChanged {[weak self] (loginTitle, imageName, bgColor) in
            self?.loginBtn.setTitle(loginTitle, for: .normal)
            self?.profileImage.image = UIImage(named: imageName)
            self?.profileImage.backgroundColor = bgColor
        }
        
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
        cell.configureCell(channel: channel)
        return cell
    }
}

extension MenuView: UITableViewDelegate {
    
}
