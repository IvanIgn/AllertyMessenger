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
        backgroundColor = .clear

        // style for recieved messages = leftSide //
        recievedMessageView.layer.cornerRadius = 12
        recievedMessageView.layer.masksToBounds = true
        recievedMessageView.backgroundColor = .white

        recievedMessageLbl.font = UIFont(name: "System Medium", size: 13.0) // System Medium 17.0
        recievedMessageLbl.textColor = .black
        recievedMessageLbl.numberOfLines = 0
        recievedMessageLbl.translatesAutoresizingMaskIntoConstraints = false

//        let constraints = [recievedMessageLbl.topAnchor.constraint(equalTo: topAnchor, constant: 16),
//        recievedMessageLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
//        recievedMessageLbl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
//        recievedMessageLbl.widthAnchor.constraint(lessThanOrEqualToConstant: 250)]
//
//        NSLayoutConstraint.activate(constraints)



        // style for sent messages = rightSide //
//        let trailingConstraint = sentMessageLbl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
//        trailingConstraint.isActive = true
//
//        let leadingConstraint = sentMessageLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
//                   leadingConstraint.isActive = false

        sentMessageView.layer.cornerRadius = 12
        sentMessageView.layer.masksToBounds = true
        sentMessageView.backgroundColor = .systemBlue

        sentMessageLbl.font = UIFont(name: "System Medium", size: 13.0)


    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    
    func configCell(message: Message) {

        self.message = message

        if message.fromID != message.chatPartnerId() {   // if users id number is equal to fromid

          //  // sent from, me right place ////

            sentMessageView.isHidden = false
            sentMessageLbl.isHidden = false
            sentMessageLbl.text = message.text

            recievedMessageView.isHidden = true
            recievedMessageLbl.isHidden = true
            recievedMessageLbl.text = ""

        } else {

          //  // sent to me, left place /////


            recievedMessageView.isHidden = false
            recievedMessageLbl.isHidden = false
            recievedMessageLbl.text = message.text

            sentMessageView.isHidden = true
            sentMessageLbl.isHidden = true
            sentMessageLbl.text = ""


        }
    }

}

