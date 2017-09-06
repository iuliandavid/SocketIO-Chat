//
//  ChannelCell.swift
//  SocketIO Chat
//
//  Created by iulian david on 9/2/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {
    
    @IBOutlet weak var channelLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
        } else {
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    func configureCell(channel: Channel) {
        let title = channel.channelTitle ?? ""
        channelLbl.text = "#\(title)"
        
        channelLbl.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        MessageServiceClient.instance.unreadChannels.value.filter{ $0 == channel.id}.forEach { (_) in
            channelLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
        }
    }

}
