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
        
        timestampLbl.text = getFormattedTimestamp(for: message.timestamp)
        timestampLbl.sizeToFit()
        messageLbl.sizeToFit()
    }

    
    /// Transforms the ISO timestamp into a custom String
    /// 2017-09-01 02:22:34.340Z
    private func getFormattedTimestamp(for timeStamp: String) -> String {
        let isoDate = timeStamp
        
        ///".340Z".count = 5
        let end = isoDate.index(isoDate.endIndex, offsetBy: -5)
        let formattedDate: String
        if #available(iOS 11, *) {
            formattedDate = String(isoDate[..<end]).appending("Z")
        } else {
            
            formattedDate = isoDate.substring(to: end).appending("Z")
        }
        
        let isoFormatter = ISO8601DateFormatter()
        let chatDate = isoFormatter.date(from: formattedDate)
        
        let chatFormatter = DateFormatter()
        chatFormatter.dateFormat = "d MMM h:mm a"
        
        if let finalDate = chatDate {
            let finalDate = chatFormatter.string(from: finalDate)
            return finalDate
        }
        
        return formattedDate
    }
}
