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
    
    @IBOutlet weak var ChatViewField: UIView!
    
    var messageId: String!
    
    var messages = [Message]()
    
    var message: Message!
    
    var currentUser = Auth.auth().currentUser?.uid
    
    var profile: Profile!
    
    var detail: DetailVC!
    
    var name = ""
    
    var curRecipientID = ""
    
    var curUsersName = KeychainWrapper.standard.string(forKey: "curUserName" )
    
    var auth: Auth!
    
    var bottomConstraint: NSLayoutConstraint?
    
    
    //var auth: Auth!
   // var usersCollectionRef: CollectionReference!
   // var messagesCollectionRef: CollectionReference!
    var chatListener: ListenerRegistration!
    var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        
            // recipient = profile.id  // user that recieves messages from current user
        curRecipientID = profile.id
        db = Firestore.firestore()
      //  usersCollectionRef = Firestore.firestore().collection("users")
       // messagesCollectionRef = Firestore.firestore().collection("messages")
        
        auth = Auth.auth()
        
        messageField.placeholder = "Type your message.."
        
        tabBarController?.tabBar.isHidden = true
    
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.alwaysBounceHorizontal = true
        
        tableView.estimatedRowHeight = 300
        
       // ============//
       // if messageId != "" && messageId != nil {

           // loadData { self.tableView.reloadData() }
       // scrollToBottom()
       // }
      //  ============//
        
       

        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)


        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
       // moveToBottom()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
//
//            self.moveToBottom()
//        }
        
        bottomConstraint = NSLayoutConstraint(item: ChatViewField!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -40)
        view.addConstraint(bottomConstraint!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationItems()
        loadData  {
        self.tableView.reloadData()
            self.scrollToBottom()
        }
       // self.chatListener.remove()
    }

    

    
    
    
    
    /// testing ////
    // works fine! //
    @objc func handleKeyboardNotification(notification: NSNotification){
        if let userInfo = notification.userInfo {
            
            let keyboardFrame =  (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            print(keyboardFrame)
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame.height : -40
        
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                
                self.view.layoutIfNeeded()
            }) { (completed) in }
            
//            if isKeyboardShowing {
//                let indexPath = IndexPath.init(item: self.messages.count - 1, section: 0)
//                self.tableView?.scrollToRow(at: indexPath, at:UITableView.ScrollPosition.bottom , animated: true)
//            }
        }
    }
    
    
    
   private func setupNavigationItems() {
            
    let navView = UIView()

    // Create the label
    let label = UILabel()
    label.text = profile.name
    label.sizeToFit()
    label.center = navView.center
    label.textAlignment = NSTextAlignment.center

    // Create the image view
    let image = UIImageView()
    image.image = profile.detailImage
    // To maintain the image's aspect ratio:
    let imageAspect = image.image!.size.width/image.image!.size.height
    // Setting the image frame so that it's immediately before the text:
    image.frame = CGRect(x: label.frame.origin.x-label.frame.size.height*imageAspect, y: label.frame.origin.y, width: label.frame.size.height*imageAspect, height: label.frame.size.height)
    image.contentMode = UIView.ContentMode.scaleAspectFit

    // Add both the label and image view to the navView
    navView.addSubview(label)
    navView.addSubview(image)

    // Set the navigation bar's navigation item's titleView to the navView
    self.navigationItem.titleView = navView

    // Set the navView's frame to fit within the titleView
    navView.sizeToFit()
        
    }

    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messages.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    
    func initData(profile: Profile) {
        self.profile = profile
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
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "Message") as? MessagesCell else {return UITableViewCell()}
        
        let messageItem = messages[indexPath.row]
        
       // if let cell = tableView.dequeueReusableCell(withIdentifier: "Message") as? MessagesCell {
            
            cell.configCell(message: messageItem)
        
            
          //  return cell
            
      //  } else {
            
        //    return MessagesCell()
        //  }
        return cell
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



//    func loadData(completed: @escaping () -> ()) {
////        chatListener = messagesCollectionRef
//      chatListener =  db.collection("messages").document(messageId).collection("messageId").order(by: "timestamp", descending: true).addSnapshotListener { (snapshot, error) in
//
//         guard error == nil else {
//                       print("Error getting the snapshot listener \(error?.localizedDescription)")
//                       return completed()
//        }
//       // if let snapshot = snapshot?.documents   {
//
//            self.messages = []
//
//
//        for document in snapshot!.documents {
//                let data = document.data()
//
//                if let postDict = data.values as? Dictionary<String, AnyObject> {
//
//                    let key = data["key"] as? String ?? "no key"
//
//                   let post = Message(messageKey: key, postData: postDict)
//
//                   self.messages.append(post)
//               }
//            }
//      //  }
//        completed()
//           // self.tableView.reloadData()
//        }
//       // completed()
//    }
////
    
    ///// Testing to get data ///////===================== ===== ========= backup after testing //////
    ///========================///
    ///==============///////========================///
    ///==============///////========================///
    ///==============///////========================///
    ///==============////
    
//    func loadData(/*completed: @escaping () -> ()*/) {
//        db.collection("messages").getDocuments()
//            {
//                (querySnapshot, err) in
//
//                if let err = err
//                {
//                    print("Error getting documents: \(err)");
//                }
//                else
//                {
//                    //  var agencyNumber = 0
//                    for document in querySnapshot!.documents {
//                        let data = document.data()
//                        let message = data["message"] as? String ?? ""
//                        let senderID = document.documentID
//                        print(message)
//                        print(senderID)
//                        //MARK get name
//
//                       // let newdocRef = Firestore.firestore().document("Agensi/\(agency)")
//
//////                        newdocRef.getDocument { (docSnapshot, error) in
//                            guard let docSnapshot = docSnapshot, docSnapshot.exists else { return }
//                            let dataDetails = docSnapshot.data()
//
//                            let agencyNew = dataDetails!["name"] as? String ?? ""
//
//                            self.messages.append(Message!)
//                            print("List of the agency: \(self.messages.append(agencyNew))")
//
//                        }
//
//                    }
//                    self.tableView.reloadData()
//                }
//        }
//      }
    
    ///========================///
    ///==============///////========================///
    ///==============///////========================///
    ///==============///////========================///
    ///==============///////========================///
    ///==============////
    
    //// Testing to retrieve all messages from database //
    
//    func loadData(/*chatId:String, finished: @escaping (String?, [ChatMessage]) -> Void*/) {
//        guard let user = self.currentUser  else { return }
//            let messageRef = self.db.collection("messages").document(messageId)
//                   // let imageRef = self.userStorage.child("\(user.uid).jpg")
//
//               // let imageRef = self.userStorage.child("contactsImages")
//
//                messageRef.getDocument { (document, error) in
//                    if let document = document, document.exists {
//                        guard let data = document.data() else { return }
//
//
//                        if let postDict = data["value"] as? Dictionary<String, AnyObject> { /*document.value(forKey: "key") as? Dictionary<String, AnyObject> *///data.values as? Dictionary<String, AnyObject> {
//
//                            let key = data["key"]//data.index(forKey: "key")
//
//                            let post = Message(messageKey: key as! String, postData: postDict)
//
////                                                   self.name = data["name"] as! String
////                                                   //self.nameLabel.text = self.name
////
////
////                                                   self.telefon = data["telefon"] as! String
////                                                   //self.telefonLabel.text = self.telefon
////
////
////
////                                                   self.email = data["email"] as! String
////                                                   //self.emailLabel.text = self.email
////
////
////                                                  // self.AddressTextField.text = self.address
////                                                   self.profdesc = data["profdesc"] as! String
//
//                                self.messages.append(post)
//                             self.tableView.reloadData()
//                            }
//
//                      //  self.descriptionTextView.text = self.profdesc
//
////                       self.photo = data["photo"] as! String
////                        print("PHOTOS URL IS: \(String(describing: data["photo"]))")
//
//                         // self.photoImage.sd_setImage(with: URL(string: data["photo"] as! String), completed: nil)
//
//
//
//                    } else {
//                        print("COULDN'T LOAD MESSAGES...")
//                    }
//                }
//       }


    /// testing 2 ///////////////====================== /// not working  as expected ...

//func loadData(completed: @escaping () -> ()) {
//       db.collection("messages").order(by: "timestamp", descending: true).addSnapshotListener { (querySnapshot, error) in
//           guard error == nil else {
//               print("Error getting the snapshot listener \(error?.localizedDescription)")
//               return completed()
//           }
//        self.messages = []
//
//           for document in querySnapshot!.documents {
//            if let postDict = document[value] as? Dictionary<String, AnyObject>
//               {
//                   let message = Message(snapshot: document)
//                let key = document[key_t]
//                    let post = Message(messageKey: key, postData: postDict)
//
//                   self.messages.append(message)
//                print("HERE IS FETCHED MESSAGES FROM DB !!! : \(self.messages)")
//               }
//           }
//           completed()
//       }
//   }


///======================= testing to send messages, last test/// working pretty well //

   @IBAction func sendPressed (_ sender: AnyObject) {
    dismissKeyboard()
           let fromID = currentUser!
           let toID = profile.id!
           //let userID = currentUser!
           let text = messageField.text!
           //let created = Date()
           let senderName = curUsersName!
           let recipientName = profile.name!
   
           if (messageField.text != nil && messageField.text != "") {
               
    
            let message = Message(fromID: fromID, toID: toID , text: text, senderName: senderName, recipientName: recipientName)
            Firestore.firestore().collection("messages").addDocument(data: message.toAny()) {
                       error in
                       if let error = error {
                           print("Error adding document: \(error.localizedDescription)")
                       }
                    
                   }
    }
     messageField.text = ""
    
}

  
       ////  ====== works =======////
       
    func loadData(completed: @escaping () -> ()) {
        chatListener = db.collection("messages").order(by:"created", descending: false).addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("Error getting the snapshot listener \(error?.localizedDescription)")
                return completed()
            }
            self.messages.removeAll() //= []

            for document in querySnapshot!.documents {
                //if (document[self.currentUser] as? String  == Auth.auth().currentUser?.uid)
              // {
                    let message = Message(snapshot: document)  //Profile(snapshot: document)
                if message.chatPartnerId() == self.profile.id {
                
                    self.messages.append(message)
                }
                print("Messages:  \(document)")
            //   }
            }

            completed()
        }
    }


    
    
    
    
    
    
///=======================
    /*
    // FIRST TEST //// Sends messages bur not really properly (Have to fix it!)
    @IBAction func sendPressed (_ sender: AnyObject) {
        
        dismissKeyboard()
        
        if (messageField.text != nil && messageField.text != "") {
            
            if messageId == nil {
                
                let post: Dictionary<String, AnyObject> = [
                    "message": messageField.text as AnyObject,
                    "sender": /*recipient*/ currentUser as AnyObject
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
              let  messageId = Firestore.firestore().collection("messages").collectionID //.document().documentID
                //messageId = messagesCollectionRef.value(forKey: "key") as? String
        
                //===============================//
                
                //let firebaseMessage = FIRDatabase.database().reference().child("messages").child(messageId).childByAutoId()
                let firebaseMessage =  Firestore.firestore().collection("messages").document(messageId)
                //firebaseMessage.setValue(post)
                
                firebaseMessage.setData(["messages" : post])
                
                
                 //===============================//
                
//                let recipentMessage = FIRDatabase.database().reference().child("users").child(recipient).child("messages").child(messageId)
                
                let recipentMessage = Firestore.firestore().collection("users").document(recipient).collection("messages").document(messageId)

////                recipentMessage.setValue(recipientMessage)
//
//               // recipentMessage.setValue(recipientMessage, forKey: "recipientMessage")
                recipentMessage.setData(["recipientMessage" : recipientMessage])
                
                 //===============================//
//                let userMessage = FIRDatabase.database().reference().child("users").child(currentUser!).child("messages").child(messageId)
                
                let userMessage = Firestore.firestore().collection("users").document(currentUser!).collection("messages").document(messageId)
                
                
//                userMessage.setValue(message)
                
               // userMessage.setValue(message, forKey: "message")
                userMessage.setData(["message" : message])
                
                
                
                 //===============================//
                loadData()// { self.tableView.reloadData() }
                
            } else if messageId != "" {
                
                let post: Dictionary<String, AnyObject> = [
                    "message": messageField.text as AnyObject,
                    "sender": /*recipient*/ currentUser as AnyObject
                ]
                
                let message: Dictionary<String, AnyObject> = [
                    "lastmessage": messageField.text as AnyObject,
                    "recipient": /*recipient*/ currentUser as AnyObject
                ]
                
                let recipientMessage: Dictionary<String, AnyObject> = [
                    "lastmessage": messageField.text as AnyObject,
                    "recipient": currentUser as AnyObject
                ]
                 //===============================//
                
//                let firebaseMessage = FIRDatabase.database().reference().child("messages").child(messageId).childByAutoId()
//
                let firebaseMessage = Firestore.firestore().collection("messages").document(messageId)
                
              //  firebaseMessage.setValue(post, forKey: "message")
                firebaseMessage.setData(["post" : post])
               // firebaseMessage.setValue(post)
                
                 //===============================//
                
//                let recipentMessage = FIRDatabase.database().reference().child("users").child(recipient).child("messages").child(messageId)
                
                let recipentMessage = Firestore.firestore().collection("users").document(recipient).collection("messages").document(messageId)
//
//               // recipentMessage.setValue(recipientMessage)
//              //  recipentMessage.setValue(recipientMessage, forKey: "lastmessage")
                recipentMessage.setData(["recipientMessage": recipientMessage])
                
                 //===============================//
//                let userMessage = FIRDatabase.database().reference().child("users").child(currentUser!).child("messages").child(messageId)
//
//                userMessage.setValue(message)
                
                
                let userMessage = Firestore.firestore().collection("users").document(currentUser!).collection("messages").document(messageId)
                                
               // userMessage.setValue(message, forKey: "recipient")
                userMessage.setData(["message": message])
                
                 //===============================//
                loadData()  // { self.tableView.reloadData() }
            }
            
            messageField.text = ""
        }
        
       // moveToBottom()
    }
    */
    @IBAction func backPressed (_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
    }
}
 
 
 

