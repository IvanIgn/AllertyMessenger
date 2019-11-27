//////
//////  ChatVC.swift
//////  AllertyMessenger
//////
//////  Created by Ivan Ignatkov on 2019-11-15.
//////  Copyright © 2019 TechCompetence. All rights reserved.
//////
////
//import Foundation
//import MessageKit
//import Firebase
//import FirebaseFirestore
//import UIKit
//import SwiftKeychainWrapper
//
//
//
//class MessageVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
//    
//    @IBOutlet weak var sendButton: UIButton!
//    
//    @IBOutlet weak var messageField: UITextField!
//    
//    @IBOutlet weak var tableView: UITableView!
//    
//    @IBOutlet weak var ChatViewField: UIView!
//    
//    var messageId: String!
//    
//    var messages = [Message]()
//    
//    var message: Message!
//    
//    var currentUser = Auth.auth().currentUser?.uid
//    
//    var profile: Profile!
//    
//    var detail: DetailVC!
//
//    //var status: Bool!
//    
//    var name = ""
//    
//    var curRecipientID = ""
//    
//    var curUsersName = KeychainWrapper.standard.string(forKey: "curUserName" )
//    
//    var auth: Auth!
//    
//    var bottomConstraint: NSLayoutConstraint?
//    
//    
//    //var auth: Auth!
//   // var usersCollectionRef: CollectionReference!
//   // var messagesCollectionRef: CollectionReference!
//    var chatListener: ListenerRegistration!
//    var db: Firestore!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//            // recipient = profile.id  // user that recieves messages from current user
//        curRecipientID = profile.id
//        db = Firestore.firestore()
//      //  usersCollectionRef = Firestore.firestore().collection("users")
//       // messagesCollectionRef = Firestore.firestore().collection("messages")
//        
//        auth = Auth.auth()
//        
//       // status = profile.isOnline
//        
//        messageField.placeholder = "Type your message.."
//        
//        tabBarController?.tabBar.isHidden = true
//    
//        
//        tableView.delegate = self
//        
//        tableView.dataSource = self
//        
//        tableView.rowHeight = UITableView.automaticDimension
//        
//        tableView.alwaysBounceHorizontal = true
//        
//        tableView.estimatedRowHeight = 300
//        
//        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
//        
//       // ============//
//       // if messageId != "" && messageId != nil {
//
//           // loadData { self.tableView.reloadData() }
//       // scrollToBottom()
//       // }
//      //  ============//
//        
//       
//
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
//        
//         NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
//
//
//        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        
//        view.addGestureRecognizer(tap)
//       // moveToBottom()
//        
////        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
////
////            self.moveToBottom()
////        }
//        
//        bottomConstraint = NSLayoutConstraint(item: ChatViewField!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -40)
//        view.addConstraint(bottomConstraint!)
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        setupNavigationItems()
//        loadData  {
//        self.tableView.reloadData()
//            self.scrollToBottom()
//        }
//       // self.chatListener.remove()
//    }
//
//    
//    
//    /// testing ////
//    // works fine! //
//    @objc func handleKeyboardNotification(notification: NSNotification){
//        if let userInfo = notification.userInfo {
//            
//            let keyboardFrame =  (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//            print(keyboardFrame)
//            
//            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
//            
//            bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame.height : -40
//        
//            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
//                
//                self.view.layoutIfNeeded()
//            }) { (completed) in }
//        }
//    }
//    
//    
//    
//   private func setupNavigationItems() {
//            
//    let navView = UIView()
//
//    // Create the label
//    let label = UILabel()
//    label.text = profile.name
//    label.sizeToFit()
//    label.center = navView.center
//    label.textAlignment = NSTextAlignment.center
//
//    // Create the image view
//    let image = UIImageView()
//    image.image = profile.detailImage
//    // To maintain the image's aspect ratio:
//    let imageAspect = image.image!.size.width/image.image!.size.height
//    // Setting the image frame so that it's immediately before the text:
//    image.frame = CGRect(x: label.frame.origin.x-label.frame.size.height*imageAspect, y: label.frame.origin.y, width: label.frame.size.height*imageAspect, height: label.frame.size.height)
//    image.contentMode = UIView.ContentMode.scaleAspectFit
//
//    // Add both the label and image view to the navView
//    navView.addSubview(label)
//    navView.addSubview(image)
//
//    // Set the navigation bar's navigation item's titleView to the navView
//    self.navigationItem.titleView = navView
//
//    // Set the navView's frame to fit within the titleView
//    navView.sizeToFit()
//        
//    }
//
//    
//    func scrollToBottom(){
//        DispatchQueue.main.async {
//            let indexPath = IndexPath(row: self.messages.count-1, section: 0)
//            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//        }
//    }
//    
//    
//    func initData(profile: Profile) {
//        self.profile = profile
//    }
//    
//    override func dismissKeyboard() {
//        
//        view.endEditing(true)
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return messages.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//         guard let cell = tableView.dequeueReusableCell(withIdentifier: "Message") as? MessagesCell else {return UITableViewCell()}
//        
//        let messageItem = messages[indexPath.row]
//        
//      
//            
//            cell.configCell(message: messageItem)
//        
//            
//        
//        return cell
//    }
//    
//
//
/////======================= testing to send messages, last test/// working pretty well //
//
//   @IBAction func sendPressed (_ sender: AnyObject) {
//    dismissKeyboard()
//           let fromID = currentUser!
//           let toID = profile.id!
//           //let userID = currentUser!
//           let text = messageField.text!
//           //let created = Date()
//           let senderName = curUsersName!
//           let recipientName = profile.name!
//   
//           if (messageField.text != nil && messageField.text != "") {
//               
//    
//            let message = Message(fromID: fromID, toID: toID , text: text, senderName: senderName, recipientName: recipientName)
//            Firestore.firestore().collection("messages").addDocument(data: message.toAny()) {
//                       error in
//                       if let error = error {
//                           print("Error adding document: \(error.localizedDescription)")
//                       }
//                    
//                   }
//    }
//     messageField.text = ""
//    
//}
//
//  
//       ////  ====== works =======////
//       
//    func loadData(completed: @escaping () -> ()) {
//        chatListener = db.collection("messages").order(by:"created", descending: false).addSnapshotListener { (querySnapshot, error) in
//            guard error == nil else {
//                print("Error getting the snapshot listener \(error?.localizedDescription)")
//                return completed()
//            }
//            self.messages.removeAll() //= []
//
//            for document in querySnapshot!.documents {
//                //if (document[self.currentUser] as? String  == Auth.auth().currentUser?.uid)
//              // {
//                    let message = Message(snapshot: document)  //Profile(snapshot: document)
//                if message.chatPartnerId() == self.profile.id {
//                
//                    self.messages.append(message)
//                }
//                print("Messages:  \(self.messages)")
//            //   }
//            }
//
//            completed()
//        }
//    }
//
//
//
//    
////
////    @IBAction func backPressed (_ sender: AnyObject) {
////
////        dismiss(animated: true, completion: nil)
////    }
////}
// 
//}
// 
//
