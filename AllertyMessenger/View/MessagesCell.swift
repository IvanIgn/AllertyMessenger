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
    
    var currentUser = Auth.auth().currentUser?.uid

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(message: Message) {
        
        self.message = message
        
        if message.sender == currentUser {
            
            sentMessageView.isHidden = false
            
            sentMessageLbl.text = message.message
            
            recievedMessageLbl.text = ""
            
            recievedMessageLbl.isHidden = true
            
        } else {
            
            sentMessageView.isHidden = true
            
            sentMessageLbl.text = ""
            
            recievedMessageLbl.text = message.message
            
            recievedMessageLbl.isHidden = false
        }
    }

}

