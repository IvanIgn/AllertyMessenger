//
//  ChatMessagesVCViewController.swift
//  AllertyMessenger
//
//  Created by Ivan Ignatkov on 2019-11-26.
//  Copyright © 2019 TechCompetence. All rights reserved.
//

import Foundation
import MessageKit
import Firebase
import FirebaseFirestore
import UIKit
import SwiftKeychainWrapper

class ChatMessagesVC: UIViewController, UITextFieldDelegate{

    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageTabelView: UITableView!
    @IBOutlet weak var ChatViewField: UIView!
    
    
    
  // var roomData : Room?
        var message: Message!
        //var messages : [Message] = []()?
        var messages = [Message]()
        var nameSender : String?
        //var messages : [String]?
        var currentUser = Auth.auth().currentUser?.uid
       
    
        
        var detail: DetailVC!
        var profile: Profile!
        
        var chatListener: ListenerRegistration!
        var db: Firestore!
    
        var name = ""
        
        var curRecipientID = ""
        
        var curUsersName = "" //KeychainWrapper.standard.string(forKey: "curUserName" )
        
        var auth: Auth!
    
        var bottomConstraint: NSLayoutConstraint?

        
    
   
        
        override func viewDidLoad() {
            super.viewDidLoad()
            //curRecipientID = profile.id
            db = Firestore.firestore()
             auth = Auth.auth()
            // hide the tab bar
         //   self.tabBarController!.tabBar.isHidden = true
            // remove the back buttom title
            
            
            //let backButton = UIBarButtonItem()
            //backButton.title = "Profile"
            //self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
            
            // make the send button circular
            self.sendButton.layer.cornerRadius = self.sendButton.frame.size.width / 2
            self.sendButton.clipsToBounds = true
            
            // set name to the navigation item with room name
           // self.navigationItem.title = roomData?.roomName
            //let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            //navigationController?.navigationBar.titleTextAttributes = textAttributes
            //messageTabelView.backgroundColor = .some()
            tabBarController?.tabBar.isHidden = true
            
            // make rounded text with border color
            self.messageTextField.layer.cornerRadius = 20
            self.messageTextField.clipsToBounds = true
            self.messageTextField.layer.borderWidth = 2.0
            self.messageTextField.layer.borderColor = #colorLiteral(red: 0.6039215686, green: 0.4, blue: 0.8274509804, alpha: 1)
            
            
            messageTabelView.dataSource = self
            messageTabelView.delegate = self
            messageTextField.delegate = self
            
            messageTextField.clearButtonMode = .whileEditing
            
            messageTextField.placeholder = "Type your message...."
           // messageTextField.textColor = UIColor(white: 90, alpha: 0.1)
            

            
            NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
                  
                   NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)


                  let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                  
                  view.addGestureRecognizer(tap)
            
            bottomConstraint = NSLayoutConstraint(item: ChatViewField!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -40)
            view.addConstraint(bottomConstraint!)
            
            //setupNavigationItems()
            
        }
        
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationItems()
        getCurUsersName()
        
        getMessageData {
            self.messageTabelView.reloadData()
            self.scrollToBottom()
//            self.getCurUsersName()
        }
        
    }
    
    override func dismissKeyboard() {
           
           view.endEditing(true)
       }
    
    func initData(profile: Profile) {
              self.profile = profile
          }
           
           
       
       func scrollToBottom(){
              DispatchQueue.main.async {
                  let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                  self.messageTabelView.scrollToRow(at: indexPath, at: .bottom, animated: true)
              }
          }
    
    
    @objc func handleKeyboardNotification(notification: NSNotification){
           if let userInfo = notification.userInfo {
               
               let keyboardFrame =  (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
               print(keyboardFrame)
               
               let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
               
               bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame.height : -40
           
               UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                   
                   self.view.layoutIfNeeded()
               }) { (completed) in }
           }
       }
    
    
        
    private func setupNavigationItems() {
                
        let navView = UIView()

        // Create the label
        
        let label = UILabel()
        if (label.text != "") {
        label.text = profile.name
        label.sizeToFit()
        label.center = navView.center
        label.textAlignment = NSTextAlignment.center
        }
        
        // Create the image view
        let image = UIImageView()
        if (image != UIImage.init(named: "addPhoto")) {
        image.image = profile.detailImage
        // To maintain the image's aspect ratio:
        let imageAspect = image.image!.size.width/image.image!.size.height
        // Setting the image frame so that it's immediately before the text:
        image.frame = CGRect(x: label.frame.origin.x-label.frame.size.height*imageAspect, y: label.frame.origin.y, width: label.frame.size.height*imageAspect, height: label.frame.size.height)
        image.contentMode = UIView.ContentMode.scaleAspectFit
        }
        // Add both the label and image view to the navView
        if (label.text != "" && image != UIImage.init(named: "addPhoto")) {
        navView.addSubview(label)
        navView.addSubview(image)
        } else {return}
        // Set the navigation bar's navigation item's titleView to the navView
        self.navigationItem.titleView = navView
        // Set the navView's frame to fit within the titleView
        navView.sizeToFit()
            
        }
    
    
    func getMessageData(completed: @escaping () -> ()) {
       /* chatListener = */db.collection("messages").order(by:"created", descending: false).addSnapshotListener { (querySnapshot, error) in
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
                print("Messages:  \(message)")
            //   }
            }

            completed()
        }
    }

    
    

      func getCurUsersName() {
           // DispatchQueue.global().async {
                guard let user = self.auth.currentUser  else { return }
                let profileRef = self.db.collection("users").document(user.uid)
               // let imageRef = self.userStorage.child("\(user.uid).jpg")

            profileRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    guard let data = document.data() else { return }

                    self.curUsersName = data["name"] as! String
                    print("Current users name is: \(self.curUsersName)")
                    //self.curUsersName = self.name
                    //self.NameTextField.text = self.name
                } else {
                    print("Document does not exist")
                }
            }
          }

    
    
    
        @IBAction func sendBtnWasPressed(_ sender: UIButton) {
            dismissKeyboard()
                    let fromID = currentUser!
                    let toID = profile.id!
                    //let userID = currentUser!
                    let text = messageTextField.text!
                    //let created = Date()
                    let senderName = "blabla" //curUsersName
                    let recipientName = profile.name!
            
                    if (messageTextField.text != nil && messageTextField.text != "") {
                        
             
                     let message = Message(fromID: fromID, toID: toID , text: text, senderName: senderName, recipientName: recipientName)
                     Firestore.firestore().collection("messages").addDocument(data: message.toAny()) {
                                error in
                                if let error = error {
                                    print("Error adding document: \(error.localizedDescription)")
                                }
                             
                            }
             }
              messageTextField.text = ""
        
    }
}

    extension ChatMessagesVC : UITableViewDataSource , UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return messages.count //?? 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? messageCell else {return UITableViewCell() }
            let curMessages = messages[indexPath.row]
            cell.updateViews(message: curMessages)
            
            if messages[indexPath.row].fromID == Auth.auth().currentUser?.uid {
                cell.checkSenderType(type: .other)
            } else {
                cell.checkSenderType(type: .me)
            }
            
            return cell
        }
}
