////
////  ChatVC.swift
////  AllertyMessenger
////
////  Created by Ivan Ignatkov on 2019-11-15.
////  Copyright © 2019 TechCompetence. All rights reserved.
////
//
import Foundation
import MessageKit
import Firebase
import FirebaseFirestore
import UIKit
import SwiftKeychainWrapper



class MessageVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var messageField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var messageId: String!
    
    var messages = [Message]()
    
    var message: Message!
    
    var currentUser = Auth.auth().currentUser?.uid
    
    var recipient: String!
    
    
    //var auth: Auth!
    var usersCollectionRef: CollectionReference!
    var messagesCollectionRef: CollectionReference!
    var advertListener: ListenerRegistration!
    var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        usersCollectionRef = Firestore.firestore().collection("users")
        messagesCollectionRef = Firestore.firestore().collection("messages")
        
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.estimatedRowHeight = 300
        
        if messageId != "" && messageId != nil {
            
            loadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        moveToBottom()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
//
//            self.moveToBottom()
//        }
    }
    
   @objc func keyboardWillShow(notify: NSNotification) {
        
        if let keyboardSize = (notify.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y == 0 {
                
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
   @objc func keyboardWillHide(notify: NSNotification) {
        
        if let keyboardSize = (notify.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y != 0 {
                
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    override func dismissKeyboard() {
        
        view.endEditing(true)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Message") as? MessagesCell {
            
            cell.configCell(message: message)
            
            return cell
            
        } else {
            
            return MessagesCell()
        }
    }
    
//    func loadData() {
//
//        FIRDatabase.database().reference().child("messages").child(messageId).observe(.value, with: { (snapshot) in
//
//            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
//
//                self.messages.removeAll()
//
//                for data in snapshot {
//
//                    if let postDict = data.value as? Dictionary<String, AnyObject> {
//
//                        let key = data.key
//
//                        let post = Message(messageKey: key, postData: postDict)
//
//                        self.messages.append(post)
//                    }
//                }
//            }
//
//            self.tableView.reloadData()
//        })
//    }



    func loadData(/*completed: @escaping () -> ()*/) {
       /* advertListener = */ messagesCollectionRef.document(currentUser!).collection(messageId).order(by: "timestamp", descending: true).addSnapshotListener { (querySnapshot, error) in
            
        guard error == nil else { return }
            //    print("Error getting the snapshot listener \(error?.localizedDescription)")
               // return completed()
         //   }
            
            self.messages = []
            
            
            for document in querySnapshot!.documents {
                let data = document.data()
                
                
                if let postDict = data as? Dictionary<String, AnyObject> {
                                       
                    let key = data["key"] as? String ?? "no key"
                   
                   let post = Message(messageKey: key, postData: postDict)
                   
                   self.messages.append(post)
               }
            }
            //completed()
            self.tableView.reloadData()
        }
    }
    
    
    
    func moveToBottom() {
        
        if messages.count > 0  {
            
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    @IBAction func sendPressed (_ sender: AnyObject) {
        
        dismissKeyboard()
        
        if (messageField.text != nil && messageField.text != "") {
            
            if messageId == nil {
                
                let post: Dictionary<String, AnyObject> = [
                    "message": messageField.text as AnyObject,
                    "sender": recipient as AnyObject
                ]
                
                let message: Dictionary<String, AnyObject> = [
                    "lastmessage": messageField.text as AnyObject,
                    "recipient": recipient as AnyObject
                ]
                
                let recipientMessage: Dictionary<String, AnyObject> = [
                    "lastmessage": messageField.text as AnyObject,
                    "recipient": currentUser as AnyObject
                ]
                
               // messageId = FIRDatabase.database().reference().child("messages").childByAutoId().key
                messageId = messagesCollectionRef.value(forKey: "key") as? String
                //===============================//
                //let firebaseMessage = FIRDatabase.database().reference().child("messages").child(messageId).childByAutoId()
                let firebaseMessage = messagesCollectionRef.document(currentUser!).collection(messageId).order(by: "timestamp", descending: false)
                //firebaseMessage.setValue(post)
                firebaseMessage.setValue(post, forKey: "post")
                 //===============================//
//                let recipentMessage = FIRDatabase.database().reference().child("users").child(recipient).child("messages").child(messageId)
                
                let recipentMessage = usersCollectionRef.document(recipient).collection("recipient").document().collection("messages").order(by: "timestamp", descending: false)
                
//                recipentMessage.setValue(recipientMessage)
                
                recipentMessage.setValue(recipentMessage, forKey: "recipentMessage")
                 //===============================//
//                let userMessage = FIRDatabase.database().reference().child("users").child(currentUser!).child("messages").child(messageId)
                
                let userMessage = usersCollectionRef.document(currentUser!).collection("messages").document().collection("messageId").order(by: "timestamp", descending: false)
                
                
//                userMessage.setValue(message)
                
                userMessage.setValue(message, forKey: "message")
                
                
                 //===============================//
                loadData()
            } else if messageId != "" {
                
                let post: Dictionary<String, AnyObject> = [
                    "message": messageField.text as AnyObject,
                    "sender": recipient as AnyObject
                ]
                
                let message: Dictionary<String, AnyObject> = [
                    "lastmessage": messageField.text as AnyObject,
                    "recipient": recipient as AnyObject
                ]
                
                let recipientMessage: Dictionary<String, AnyObject> = [
                    "lastmessage": messageField.text as AnyObject,
                    "recipient": currentUser as AnyObject
                ]
                 //===============================//
//                let firebaseMessage = FIRDatabase.database().reference().child("messages").child(messageId).childByAutoId()
//
               let firebaseMessage = usersCollectionRef.document(currentUser!).collection("messages").document().collection("messageId").order(by: "timestamp", descending: false)
                
                firebaseMessage.setValue(post, forKey: "post")
               // firebaseMessage.setValue(post)
                 //===============================//
//                let recipentMessage = FIRDatabase.database().reference().child("users").child(recipient).child("messages").child(messageId)
                
                let recipentMessage = usersCollectionRef.document(recipient).collection("recipient").document().collection("messages").order(by: "timestamp", descending: false)
            
               // recipentMessage.setValue(recipientMessage)
                recipentMessage.setValue(recipentMessage, forKey: "recipentMessage")
                 //===============================//
//                let userMessage = FIRDatabase.database().reference().child("users").child(currentUser!).child("messages").child(messageId)
//
//                userMessage.setValue(message)
                
                
                let userMessage = usersCollectionRef.document(currentUser!).collection("messages").document().collection("messageId").order(by: "timestamp", descending: false)
                                
                                
                userMessage.setValue(message, forKey: "message")
                 //===============================//
                loadData()
            }
            
            messageField.text = ""
        }
        
        moveToBottom()
    }
    
    @IBAction func backPressed (_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
    }
}
