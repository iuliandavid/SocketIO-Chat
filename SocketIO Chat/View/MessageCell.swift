//
//  MessageCell.swift
//  SocketIO Chat
//
//  Created by iulian david on 9/3/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var timestampLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(for message: Message) {
        avatarImage.image = UIImage(named: message.userAvatar)
        avatarImage.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvatarColor)
        messageLbl.text = message.message
        usernameLbl.text = message.userName
        timestampLbl.text = message.timestamp
        timestampLbl.sizeToFit()
        messageLbl.sizeToFit()
    }

}
