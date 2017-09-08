//
//  StringToCustomNSAttributedString.swift
//  SocketIO Chat
//
//  Created by iulian david on 9/6/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import UIKit

//MARK - String extension for returning custom color NSAttributedString
extension String {
    func getCustomAttributedText(foregroundColor: UIColor? = Constants.textPlaceholderColor) -> NSAttributedString {
        let attrs = [NSAttributedStringKey.foregroundColor: foregroundColor as Any] as [NSAttributedStringKey : Any]
        
        return NSAttributedString(string: self, attributes: attrs)
    }
}
