//
//  AvatarCell.swift
//  SocketIO Chat
//
//  Created by iulian david on 8/31/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import UIKit

class AvatarCell: UICollectionViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var imageStringAndColor: (imageString: String, type: AvatarType)? {
        didSet {
            updateCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    func updateCell() {
        guard let (imageString, type) = imageStringAndColor else {
            return
        }
        avatarImageView.image = UIImage(named: imageString)
        switch type {
        case .light:
            self.layer.backgroundColor = UIColor.gray.cgColor
        case .dark:
            self.layer.backgroundColor = UIColor.lightGray.cgColor
        }
    }
}
