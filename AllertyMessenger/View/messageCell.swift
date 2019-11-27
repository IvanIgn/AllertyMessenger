//
//  messageCell.swift
//  AllertyMessenger
//
//  Created by Ivan Ignatkov on 2019-11-26.
//  Copyright © 2019 TechCompetence. All rights reserved.
//

import UIKit

class messageCell: UITableViewCell {
    var message: Message!
    var cmVC = ChatMessagesVC()
    
    enum senderType {
        case me
        case other
    }
    
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var messageContent: UITextView!
    @IBOutlet weak var messageStackView: UIStackView!
    @IBOutlet weak var bubleView: GradientView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateViews(message : Message!){
        //self.message = message
        //self.senderName.text = message.senderName //  .senderName?.capitalized
        self.messageContent.text = message.text
    }
    
    func checkSenderType(type : senderType)  {
        if type == .me {
            messageStackView.alignment = .leading
            bubleView.topColor = #colorLiteral(red: 0.2145429038, green: 0.2131613247, blue: 0.3235149662, alpha: 1)
            bubleView.bottomColor = #colorLiteral(red: 0.1467744036, green: 0.1458292292, blue: 0.2213250375, alpha: 1)
            bubleView.startPointX = 0
            bubleView.startPointY = 1
            bubleView.endPointX  = 1
            bubleView.endPointY = 0
            bubleView.cornerRadius = 10
          //  self.senderName.text =  message.senderName?.capitalized //recipientName //.capitalized
        } else if type == .other {
            messageStackView.alignment = .trailing
            bubleView.topColor = #colorLiteral(red: 0.4470588235, green: 0.5058823529, blue: 0.8941176471, alpha: 1)
            bubleView.bottomColor = #colorLiteral(red: 0.631372549, green: 0.431372549, blue: 0.8941176471, alpha: 1)
            bubleView.startPointX = 0
            bubleView.startPointY = 1
            bubleView.endPointX  = 1
            bubleView.endPointY = 0
            bubleView.cornerRadius = 10
           // self.senderName.text = message.senderName?.capitalized

        }
    }
}
