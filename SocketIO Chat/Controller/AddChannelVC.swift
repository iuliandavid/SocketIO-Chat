//
//  AddChannelVC.swift
//  SocketIO Chat
//
//  Created by iulian david on 9/2/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var descriptionTxt: UITextField!
    
    private var messageService: MessageService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messageService = MessageServiceClient.instance
        setupView()
    }
    
    fileprivate func setupView() {
        nameTxt.attributedPlaceholder = "Name".getCustomAttributedText()
        descriptionTxt.attributedPlaceholder = "Description".getCustomAttributedText()
        
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        bgView.addGestureRecognizer(closeTap)
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeModalPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createChannelPressed(_ sender: Any) {
        guard let name = nameTxt.text, name != "",
            let description = descriptionTxt.text else {
                return
        }
        messageService.addChannel(channelName: name, channelDescription: description) { [weak self] (success, _) in
            if success {
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
