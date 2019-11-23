////
////  messageDetailCell.swift
////  AllertyMessenger
////
////  Created by Ivan Ignatkov on 2019-11-20.
////  Copyright © 2019 TechCompetence. All rights reserved.
////
//
//import Foundation
//import UIKit
//import Firebase
//import FirebaseFirestore
////import FirebaseStorage
//import SwiftKeychainWrapper
//
//class messageDetailCell: UITableViewCell {
//    
//    @IBOutlet weak var recipientImg: UIImageView!
//    
//    @IBOutlet weak var recipientName: UILabel!
//    
//    @IBOutlet weak var chatPreview: UILabel!
//    
//    var messageDetail: MessageDetail!
//    
//    var userPostKey: Firestore.firestore()
//    
//    let currentUser = KeychainWrapper.standard.string(forKey: "uid")
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//    func configureCell(messageDetail: MessageDetail) {
//        
//        self.messageDetail = messageDetail
//        
//        //let recipientData = FIRDatabase.database().reference().child("users").child(messageDetail.recipient)
//        
//        let recipientdata = Firestore.firestore().collection("users").document(messageDetail.recipient)
//    
//           recipientData.observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            let data = snapshot.value as! Dictionary<String, AnyObject>
//            
//            let username = data["username"]
//            
//            let userImg = data["userImg"]
//            
//            self.recipientName.text = username as? String
//            
//            let ref = FIRStorage.storage().reference(forURL: userImg! as! String)
//            
//            ref.data(withMaxSize: 100000, completion: { (data, error) in
//                
//                if error != nil {
//                    print("could not load image")
//                } else {
//                    
//                    if let imgData = data {
//                        
//                        if let img = UIImage(data: imgData) {
//                            
//                            self.recipientImg.image = img
//                        }
//                    }
//                }
//            })
//        })
//    }
//}
