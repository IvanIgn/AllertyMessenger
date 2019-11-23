//
//  MessagesCell.swift
//  AllertyMessenger
//
//  Created by Ivan Ignatkov on 2019-11-15.
//  Copyright © 2019 TechCompetence. All rights reserved.
//


import UIKit
import Foundation
import SwiftKeychainWrapper
import Firebase
import FirebaseFirestore

class MessagesCell: UITableViewCell {
    
    @IBOutlet weak var recievedMessageLbl: UILabel!
    
    @IBOutlet weak var recievedMessageView: UIView!
    
    @IBOutlet weak var sentMessageLbl: UILabel!
    
    @IBOutlet weak var sentMessageView: UIView!
    
    var message: Message!
    //var bla: MessageVC!
    
    var currentUser = Auth.auth().currentUser?.uid

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        recievedMessageView.layer.cornerRadius = 5;
        recievedMessageView.layer.masksToBounds = true;
        
        sentMessageView.layer.cornerRadius = 5;
        sentMessageView.layer.masksToBounds = true;
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(message: Message) {
        
        self.message = message
        
        if message.fromID != message.chatPartnerId() {                // message.fromID ==  currentUser

            sentMessageView.isHidden = false

            sentMessageLbl.text = message.text

            recievedMessageLbl.text = ""
            
            recievedMessageLbl.isHidden = true

        } else {

            sentMessageView.isHidden = true

            sentMessageLbl.text = ""

            recievedMessageLbl.text = message.text

            recievedMessageLbl.isHidden = false
        }
    }

}

