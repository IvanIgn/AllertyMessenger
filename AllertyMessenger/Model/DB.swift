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

class Contact {
    
    var image: String!
    var contactName: String!
    //var price: String!
    var location: String!
    var telefon: String!
    var contactDesc: String!
    var timestamp: Date!
    var documentID: String!
    var detailImage: UIImage!

    
    init(image: String, contactName: String, location: String, telefon: String, contactDesc: String) {
        self.image = image
        self.contactName = contactName
        self.location = location
        self.telefon = telefon
        self.contactDesc = contactDesc
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        image = snapshot["image"] as? String ?? ""
        contactName = snapshot["contactName"] as? String ?? "contact name"
        //price = snapshot["price"] as? String ?? "0"
        location = snapshot["location"] as? String ?? "default location"
        telefon = snapshot["telefon"] as? String ?? "default telefon"
        contactDesc = snapshot["contactDesc"] as? String ?? "some words about contact..."
        timestamp = snapshot["timestamp"] as? Date ?? Date()
       
        // timestamp = snapshot["timestamp"] as? Date
        
        documentID = snapshot.documentID
    }
    
    
    func toAny() -> [String: Any] {
        return ["image": image,
                "contactName": contactName != "" ? contactName : "no contact name",
                //"price": price != "" ? price : "no product price",
                "location": location != "" ? location : "no location",
                "telefon": telefon != "" ? telefon : "no telefon number",
                "contactDesc": contactDesc != "" ? contactDesc : "no contact description",
                "timestamp":  FieldValue.serverTimestamp() ]
    }
}


class Profile {
    
    var id: String!
    var name: String!
    var telefon: String!
    var email: String!
    var address: String!
    var photo: String?
    var timestamp: Date!
    var detailImage: UIImage!


    init(name: String, telefon: String, email: String, address: String, photo: String) {
        self.name = name
        self.telefon = telefon
        self.email = email
        self.address = address
        self.photo = photo
    }

    init(snapshot: QueryDocumentSnapshot) {
        id = snapshot[id] as? String ?? "\(Auth.auth().currentUser)"
        name = snapshot["name"] as? String ?? "user"
        telefon = snapshot["telefon"] as? String ?? "default telefon"
        email = snapshot["email"] as? String ?? "x@x.com"
        address = snapshot["address"] as? String ?? "some address"
        photo = snapshot["photo"] as? String ?? ""
        timestamp = snapshot["timestamp"] as? Date ?? Date()
    }


    func toAny() -> [String: Any] {
        return ["id": Auth.auth().currentUser?.uid,
                "name": name != "" ? name : "no name",
                "telefon": telefon != "" ? telefon : "no telephone",
                "email": email != "" ? email : "no email"/*"\(NSLocalizedString("addmail", comment: ""))"*/,
                "address": address != "" ? address : "no address",
                "photo": photo,
                "timestamp":  FieldValue.serverTimestamp() ]
    }
}
