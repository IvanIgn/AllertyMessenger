//
//  DB.swift
//  AllertyMessenger1.0
//
//  Created by Ivan Ignatkov on 2019-10-31.
//  Copyright © 2019 TechCompetence. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore


let locProdName = NSLocalizedString("no product name", comment: "")
let locProdPrice = NSLocalizedString("no product price", comment: "")
let locLocation = NSLocalizedString("no location", comment: "")
let locProdTel = NSLocalizedString("no telefon number", comment: "")
let locProdDesc = NSLocalizedString("no description", comment: "")

let db = Firestore.firestore()

//class Message {
//
//    private var _message: String!
//
//    private var _sender: String!
//
//    private var _messageKey: String!
//
//    private var _messageRef: CollectionReference!
//
//    var currentUser = Auth.auth().currentUser?.uid
////    var profile: Profile!
////    var messageText: String!
////    var messageID: String!
//
//
//    init(message: String, sender: String ) {
//        _message = message
//        _sender = sender
//    }
//
//    init(messageKey: String, postData: Dictionary<String, AnyObject>) {
//
//        _messageKey = messageKey
//
//        if let message = postData["message"] as? String {
//
//            _message = message
//        }
//
//        if let sender = postData["sender"] as? String {
//
//            _sender = sender
//        }
//
//        _messageRef = Firestore.firestore().collection("messages").document(currentUser!).collection(_messageKey)
//    }
//
//    init(snapshot: QueryDocumentSnapshot) {
//        _message = snapshot["message"] as? String ?? "no message"
//        _sender = snapshot["sender"] as? String ?? "no message sender"
//        _messageKey = snapshot["messageKey"] as? String ?? "no message key"
//
//
//
//        // timestamp = snapshot["timestamp"] as? Date
//
//            // documentID = snapshot.documentID
//    }
//
//
//    func toAny() -> [String: Any] {
//        return ["_message": _message != "" ? _message: "no message",
//                "_sender": _sender != "" ? _sender : "no sender",
//                "_messageKey": _messageKey != "" ? _messageKey : "no message key"]
//    }
//
//
//}

 class Message  {
    
    private var _message: String!
    
    private var _sender: String!
    
    private var _messageKey: String!
    
    private var _messageRef: DocumentReference!
    
    var currentUser = Auth.auth().currentUser?.uid
    
    var message: String {
        
        return _message
    }
    
    var sender: String {
        
        return _sender
    }
    
    var messageKey: String{
    
        return _messageKey
    }
    
    init(message: String, sender: String) {
        
        _message = message
        
        _sender = sender
    }
    
    init(messageKey: String, postData: Dictionary<String, AnyObject>) {
        
        _messageKey = messageKey
        
        if let message = postData["message"] as? String {
            
            _message = message
        }
        
        if let sender = postData["sender"] as? String {
            
            _sender = sender
        }
        
        _messageRef = db.collection("messages").document(_messageKey)
          //  FIRDatabase.database().reference().child("messages").child(_messageKey)
    }
}


class Profile {
    
    var id: String!
    var name: String!
    var telefon: String!
    var email: String!
    var photo: String?
    var timestamp: Date!
    var detailImage: UIImage!
    var profdesc: String!


    init(name: String, telefon: String, email: String, photo: String, profdesc: String ) {
        self.name = name
        self.telefon = telefon
        self.email = email
        self.photo = photo
        self.profdesc = profdesc
    }

    init(snapshot: QueryDocumentSnapshot) {
        id = snapshot["id"] as? String ?? "\(Auth.auth().currentUser)"
        name = snapshot["name"] as? String ?? "user"
        telefon = snapshot["telefon"] as? String ?? "default telefon"
        email = snapshot["email"] as? String ?? "x@x.com"
        photo = snapshot["photo"] as? String ?? ""
        timestamp = snapshot["timestamp"] as? Date ?? Date()
        profdesc = snapshot["profdesc"] as? String ?? "some description"
    }


    func toAny() -> [String: Any] {
        return ["id": Auth.auth().currentUser?.uid,
                "name": name != "" ? name : "no name",
                "telefon": telefon != "" ? telefon : "no number",
                "email": email != "" ? email : "no email",       /*"\(NSLocalizedString("addmail", comment: ""))"*/
                "photo": photo,
                "timestamp":  FieldValue.serverTimestamp(),
                "profdesc": profdesc != "" ? profdesc : "no description"]
    }
}



