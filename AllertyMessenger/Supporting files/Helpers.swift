//
//  Helpers.swift
//  AllertyMessenger
//
//  Created by Ivan Ignatkov on 2019-11-24.
//  Copyright © 2019 TechCompetence. All rights reserved.
//

import Foundation
import MessageKit
import Firebase
import FirebaseFirestore
import UIKit
import SwiftKeychainWrapper

var profile: Profile!
var abc = KeychainWrapper.standard.bool(forKey: "status")




//func loadStatus(status: Bool) {
//
//        //        if Reachability.isConnectedToNetwork() {
//        //            isOnline = true
//        //        }
//
//    let curStatus = status
//    let db = Firestore.firestore()
//    let auth = Auth.auth().currentUser?.uid
//
//    if curStatus == true {
//    db.collection("users").document(auth!).updateData([
//        "isOnline": AppDelegate.Status as Bool //true
//    ]) { err in
//        if let err = err {
//            print("Error updating document: \(err)")
//        } else {
//            print("Document successfully updated")
////            var status = profile.isOnline
////            status = true
////            UserDefaults.standard.set(status, forKey: "status")
//        }
//     }
//    }
//    else {
//        db.collection("users").document(auth!).updateData([
//                "isOnline": false
//            ]) { err in
//                if let err = err {
//                    print("Error updating document: \(err)")
//                } else {
//                    print("Document successfully updated")
////                    var status = profile.isOnline
////                    status = true
////                    UserDefaults.standard.set(status, forKey: "status")
//                }
//             }
//       }
//    //return curStatus
//}


func updateStatus(setStatus: Bool) {

        //        if Reachability.isConnectedToNetwork() {
        //            isOnline = true
        //        }

    //let curStatus = status
    let db = Firestore.firestore()
    guard let auth = Auth.auth().currentUser?.uid else { return }
    
    //if curStatus == true {
    db.collection("users").document(auth).updateData([
        "isOnline": setStatus //true
    ]) { err in
        if let err = err {
            print("Error updating document: \(err)")
        } else {
            print("Document successfully updated")
//            var status = profile.isOnline
//            status = true
//            UserDefaults.standard.set(status, forKey: "status")
        }
     }
    }
  

//func updateStatus(status: Bool)  {
//    if status == true {
//    UserDefaults.standard.set(status, forKey: "status")
//
//    }
//    else {
//        UserDefaults.standard.removeObject(forKey: "status")
//
//    }
//
//}
