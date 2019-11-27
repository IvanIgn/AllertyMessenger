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
  var text: String!
  var created: Date!
  var senderName: String!
  var recipientName: String!
  

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
              text = snapshot["text"] as? String ?? "text"
              created = snapshot["created"] as? Date ?? Date()
              senderName = snapshot["senderName"] as? String ?? "senderName"
              recipientName = snapshot["recipientName"] as? String ?? "recipientName"
          }

    func toAny() -> [String: Any] {
              return ["fromID": fromID != "" ? fromID : "no senderID" ,
                      "toID": toID != "" ? toID : "no recipientID",
                       "text": text != "" ? text : "no message text",
                       "created": FieldValue.serverTimestamp(),
                       "senderName": senderName != "" ? senderName : "no senderName",
                       "recipientName": recipientName != "" ? recipientName : "no recipientName"
                       ]      /*"\(NSLocalizedString("addmail", comment: ""))"*/
           }
    
    func chatPartnerId() -> String? {
        return fromID == Auth.auth().currentUser?.uid ? toID : fromID
    }
    
    
}




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
    var isOnline: Bool!
    

    init(id: String, name: String, telefon: String, email: String, photo: String, profdesc: String/*, isOnline: Bool*/ ) {
        self.id = id
        self.name = name
        self.telefon = telefon
        self.email = email
        self.photo = photo
        self.profdesc = profdesc
       // self.isOnline = isOnline
    }

    init(snapshot: QueryDocumentSnapshot) {
        isOnline = snapshot["isOnline"] as? Bool ?? Bool()
        id = snapshot["id"] as? String ?? "usersID"//"\(Auth.auth().currentUser)"
        name = snapshot["name"] as? String ?? "user"
        telefon = snapshot["telefon"] as? String ?? "default telefon"
        email = snapshot["email"] as? String ?? "x@x.com"
        photo = snapshot["photo"] as? String ?? ""
        timestamp = snapshot["timestamp"] as? Date ?? Date()
        profdesc = snapshot["profdesc"] as? String ?? "some description"
    }


    func toAny() -> [String: Any] {
        return ["isOnline": isOnline == true ? true : false, //false
                "id": Auth.auth().currentUser?.uid,
                "name": name != "" ? name : "no name",
                "telefon": telefon != "" ? telefon : "no number",
                "email": email != "" ? email : "no email",       /*"\(NSLocalizedString("addmail", comment: ""))"*/
                "photo": photo,
                "timestamp":  FieldValue.serverTimestamp(),
                "profdesc": profdesc != "" ? profdesc : "no description"]
       
    }
    func checkUserPresense() -> Bool? {
           return isOnline == Reachability.isConnectedToNetwork() ? true : false
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


extension Profile {

func setStatus() {
          let db = Firestore.firestore()
          let auth = Auth.auth().currentUser?.uid
    
    let online = isOnline

          db.collection("users").document(auth!).updateData([
              "isOnline": true
          ]) { err in
              if let err = err {
                  print("Error updating document: \(err)")
              } else {
                  print("Document successfully updated")
                  UserDefaults.standard.set(online, forKey: "status")
              }
          }
}
}
