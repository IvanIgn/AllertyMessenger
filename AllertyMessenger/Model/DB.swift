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

class Message {


  var fromID: String!
  var toID: String!
//  var userID: String!
  var text: String!
  var created: Date!
  var senderName: String!
  var recipientName: String!

//  var dictionary:[String:Any] {
//      return [
//          "name": userName,
//          "userId": userId,
//          "created": created,
//          "text": text
//      ]
//  }

    init(fromID: String, toID: String , text: String/*, created: Date*/, senderName: String, recipientName: String) {
      self.fromID = fromID
      self.toID = toID
      //self.userID = userID
      self.text = text
     // self.created = created
      self.senderName = senderName
      self.recipientName = recipientName
  }


     init(snapshot: QueryDocumentSnapshot) {
              fromID = snapshot["fromID"] as? String ?? "senderID"
              toID = snapshot["toID"] as? String ?? "recipientID"
             // userID = snapshot["userID"] as? String ?? "userID"
              text = snapshot["text"] as? String ?? "text"
              created = snapshot["created"] as? Date ?? Date()
              senderName = snapshot["senderName"] as? String ?? "senderName"
              recipientName = snapshot["recipientName"] as? String ?? "recipientName"
          }

    func toAny() -> [String: Any] {
              return ["fromID": fromID != "" ? fromID : "no senderID" ,
                      "toID": toID != "" ? toID : "no recipientID",
                      // "userID": userID != "" ? userID : "no UserID",
                       "text": text != "" ? text : "no message text",
                       "created": FieldValue.serverTimestamp(),
                       "senderName": senderName != "" ? senderName : "no senderName",
                       "recipientName": recipientName != "" ? recipientName : "no recipientName"]      /*"\(NSLocalizedString("addmail", comment: ""))"*/
           }
    
    func chatPartnerId() -> String? {
        return fromID == Auth.auth().currentUser?.uid ? toID : fromID
    }
    
}

// class Message  {
//
//   private var _message: String!
//
//   private var _sender: String!
//
//   private var _messageKey: String!
//
//   private var _messageRef: DocumentReference!
//
//    var currentUser = Auth.auth().currentUser?.uid
//
//    var message: String {
//
//        return _message
//    }
//
//    var sender: String {
//
//        return _sender
//    }
//
//    var messageKey: String{
//
//        return _messageKey
//    }
//
//    init(message: String, sender: String) {
//
//        _message = message
//
//        _sender = sender
//    }
//
//    init(messageKey: String, postData: Dictionary<String, AnyObject>) {
//
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
//        _messageRef = db.collection("messages").document(_messageKey)
//          //  FIRDatabase.database().reference().child("messages").child(_messageKey)
//    }
//}
//    init(snapshot: QueryDocumentSnapshot) {
//        message = snapshot["message"] as? String ?? "no message"
//        sender = snapshot["sender"] as? String ?? "user"
//        messageKey = snapshot["messageKey"] as? String ?? "default telefon"
//        currentUser = snapshot["currentUser"] as? String ?? "\(Auth.auth().currentUser)"
//    }

//
//


//class MessageDetail {
//
//    private var _recipient: String!
//
//    private var _messageKey: String!
//
//    private var _messageRef: DocumentReference!
//
//    var currentUser = Auth.auth().currentUser?.uid
//
//    var recipient: String {
//
//        return _recipient
//    }
//
//    var messageKey: String {
//
//        return _messageKey
//    }
//
//    var messageRef: DocumentReference {
//
//        return _messageRef
//    }
//
//    init(recipient: String) {
//
//        _recipient = recipient
//    }
//
//    init(messageKey: String, messageData: Dictionary<String, AnyObject>) {
//
//        _messageKey = messageKey
//
//        if let recipient = messageData["recipient"] as? String {
//
//            _recipient = recipient
//        }
//
//        _messageRef = db.collection("recipient").document(_messageKey)
//          //  FIRDatabase.database().reference().child("recipient").child(_messageKey)
//    }
//}

//class Message {
//   var date : String
//   var message : String
//   var rDel : String
//   var rid : String
//   var rName : String
//   var sDel : String
//   var sid : String
//   var sName : String
//   var type : String
//   var messageId : String
//   var chatId : String
//  // var duration : String
//
//    init(date: String, message: String, rDel: String, rid: String, rName: String, sDel: String, sid: String, sName: String, type: String, messageId: String, chatId: String) {
//        self.date = date
//        self.message = message
//        self.rDel = rDel
//        self.rid = rid
//        self.rName = rName
//        self.sDel = sDel
//        self.sid = sid
//        self.sName = sName
//        self.type = type
//        self.messageId = messageId
//        self.chatId = chatId
//    }
//
//
//    init(snapshot: QueryDocumentSnapshot) {
//          date = snapshot["date"] as? String ?? ""
//          message = snapshot["message"] as? String ?? "message"
//          rDel = snapshot["rDel"] as? String ?? "rDel"
//          rid = snapshot["rid"] as? String ?? "rid"
//          rName = snapshot["rName"] as? String ?? "rName"
//          sDel = snapshot["sDel"] as? String ?? "sDel"
//          sid = snapshot["sid"] as? String ?? "sid"
//          sName = snapshot["sName"] as? String ?? "sName"
//          type = snapshot["type"] as? String ?? "type"
//          messageId = snapshot["messageId"] as? String ?? "messageId"
//          chatId = snapshot["chatId"] as? String ?? "chatId"
//
//      }
//
//    func toAny() -> [String: Any] {
//            return ["date": date != "" ? date: "no date" ,
//                   "message": message != "" ? message : "no message",
//                   "rDel": rDel != "" ? rDel : "no rDel",
//                   "rid": rid != "" ? rid : "no rid",       /*"\(NSLocalizedString("addmail", comment: ""))"*/
//                   "rName": rName != "" ? rName : "rName",
//                   "sDel": sDel != "" ? sDel : "sDel",
//                   "sid": sid != "" ? sid : "sid",
//                   "sName": sName != "" ? sName : "sName",
//                   "type": type != "" ? type : "type",
//                   "messageId": messageId != "" ? messageId : "messageId",
//                   "chatId": chatId != "" ? chatId : "chatId"]
//       }
//
//}

class Profile {
   // var isOnline: Bool!
    
    
    var id: String!
    var name: String!
    var telefon: String!
    var email: String!
    var photo: String?
    var timestamp: Date!
    var detailImage: UIImage!
    var profdesc: String!


    init(id: String, name: String, telefon: String, email: String, photo: String, profdesc: String ) {
        self.id = id
        self.name = name
        self.telefon = telefon
        self.email = email
        self.photo = photo
        self.profdesc = profdesc
    }

    init(snapshot: QueryDocumentSnapshot) {
        id = snapshot["id"] as? String ?? "usersID"//"\(Auth.auth().currentUser)"
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

//extension Message {
//    
//    //MARK: - initializer
//    convenience init?(documentId: String, dictionary: [String : Any]) {
//        guard let userName = dictionary["name"] as? String,
//        let userId = dictionary["userId"] as? String,
//        let created = dictionary["created"] as? Date,
//        let text = dictionary["text"] as? String
//            else {
//                return nil
//        }
//        
//        self.init(documentId: documentId, text: text, created: created, userName: userName, userId: userId)
//    }
//}


