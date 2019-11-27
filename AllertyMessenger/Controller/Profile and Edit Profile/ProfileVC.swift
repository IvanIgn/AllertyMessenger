//
//  HomeViewController.swift
//  Smarket
//
//  Created by Ivan Ignatkov on 2019-03-07.
//  Copyright © 2019 TechCompetence. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage
import SwiftKeychainWrapper

//var pTel: String!
class ProfileVC: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate , UITextViewDelegate {

  
    @IBOutlet weak var nameLabel1: UILabel!
    //@IBOutlet weak var nameLabel: UILabel!
    //@IBOutlet weak var telefonLabel: UILabel!
    @IBOutlet weak var telefonLabel1: UILabel!
   // @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailLabel1: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!  //@IBOutlet weak var addressLabel1: UILabel!
    
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var TelTextFierld: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    
    
    var db: Firestore!
    var auth: Auth!
    var profile: Profile!
    var userStorage: StorageReference!
   // var advertCollectionRef: CollectionReference!
    
    var name = ""
    var telefon = ""
    var email = ""
   // var address = ""
    var photo = "" ///*UIImage.self*/ UIImage(named: "profileLogo")
    var profdesc = ""
    var trigger = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  print("Current users status is: \(status)")
        
        db = Firestore.firestore()
        auth = Auth.auth()
         
        
        let storage = Storage.storage().reference(forURL: "gs://allertymessenger.appspot.com")
        userStorage = storage.child("contactsImages")
      
        KeychainWrapper.standard.set(name, forKey: "curUserName")
        
        
       // advertCollectionRef = Firestore.firestore().collection("users")
        photoImage.layer.cornerRadius = 90
        photoImage.clipsToBounds = true
        
        NameTextField.layer.cornerRadius = 5
        NameTextField.layer.borderWidth = 2
        NameTextField.layer.borderColor = CGColor.init(srgbRed: 0.0, green: 0.0, blue: 255.0, alpha: 1)
        
        TelTextFierld.layer.cornerRadius = 5
        TelTextFierld.layer.borderWidth = 2
        TelTextFierld.layer.borderColor = CGColor.init(srgbRed: 0.0, green: 0.0, blue: 255.0, alpha: 1)
        
        EmailTextField.layer.cornerRadius = 5
        EmailTextField.layer.borderWidth = 2
        EmailTextField.layer.borderColor = CGColor.init(srgbRed: 0.0, green: 0.0, blue: 255.0, alpha: 1)
        
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.layer.borderWidth = 2
        descriptionTextView.layer.borderColor = CGColor.init(srgbRed: 0.0, green: 0.0, blue: 255.0, alpha: 1)
        
         
        
       
        
//        nameLabel1.font = UIFont.boldSystemFont(ofSize: 17)
//        telefonLabel1.font = UIFont.boldSystemFont(ofSize: 17)
//        emailLabel1.font = UIFont.boldSystemFont(ofSize: 17)
//        addressLabel1.font = UIFont.boldSystemFont(ofSize: 17)
        
        
//        NameTextField.text = name
//        TelTextFierld.text = telefon
//        EmailTextField.text = email
//        AddressTextField.text = address
       
        
//       NameTextField.delegate = self
//       TelTextFierld.delegate = self
//       EmailTextField.delegate = self
//       AddressTextField.delegate = self
        
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .close, target: self, action: #selector(outLoged))
//        if (auth.currentUser?.uid == nil) {
        
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Logout", style: .plain, target: self, action: #selector(outLoged))
            updateStatus(setStatus: false)
        
//        } else {
            // let uid = auth.currentUser?.uid == nil
          //  advertCollectionRef.
//        }
        
      //  getProfileData()
       
    }
    
    
    @objc func outLoged(_sender: UIBarButtonItem) {
        // self.navigationController!.popViewController(animated: true)
       // Auth.auth().signOut()
      
       
         let uuid = UUID().uuidString.lowercased()
        do {
            try Auth.auth().signOut()
           // profile.isOnline = false  // user is ofline
            
            
            print("USER: \(uuid) HAS LOGGED OUT")
            
        } catch let logoutError {
            print(logoutError)
        }
       
         self.dismiss(animated: true, completion: nil)
       // let startController = StartVC()
       //present(startController, animated: false, completion: nil)
       // updateStatus(setStatus: false)
        }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            getProfileData()
    }
    

    
    
    func getProfileData() {
       // DispatchQueue.global().async {
            guard let user = self.auth.currentUser  else { return }
            let profileRef = self.db.collection("users").document(user.uid)
           // let imageRef = self.userStorage.child("\(user.uid).jpg")
        
        let imageRef = self.userStorage.child("contactsImages")
        
        
//        imageRef.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                self.image = UIImage(data: data!)
//                self.photoImage.image = self.image
//            }
//     }
        
//        imageRef.downloadURL { (url, error) in
//            guard let downloadURL = url else { return }
//            self.photoImage.sd_setImage(with: downloadURL, completed: nil)
//        }
        
      //  DispatchQueue.global().async {
        
        //////// TESTING ///////////
//            imageRef.downloadURL { (url, error) in
//                guard let downloadURL = url else { return }
//
//                    self.photoImage.sd_setImage(with: downloadURL, completed: nil)
//                }
        
        
        
        profileRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let data = document.data() else { return }
                
                self.name = data["name"] as! String
                //self.nameLabel.text = self.name
                self.NameTextField.text = self.name
                
                self.telefon = data["telefon"] as! String
                //self.telefonLabel.text = self.telefon
                self.TelTextFierld.text = self.telefon
                
                
                self.email = data["email"] as! String
                //self.emailLabel.text = self.email
                self.EmailTextField.text = self.email
               
               // self.address = data["address"] as! String
                //self.addressLabel.text = self.address
               // self.AddressTextField.text = self.address
                self.profdesc = data["profdesc"] as! String 
                self.descriptionTextView.text = self.profdesc
                
               // self.status = (data["isOnline"] as! Bool)
              //  print("Status is: \(String(describing: self.status))")
                
                //self.isOnline = data["isOnline"] as! Bool
                //self.isOnline = true
                
               self.photo = data["photo"] as! String
                print("PHOTOS URL IS: \(String(describing: data["photo"]))")
                
                  self.photoImage.sd_setImage(with: URL(string: data["photo"] as! String), completed: nil)
                

                
            } else {
                print("Document does not exist")
            }
        }
      }
    
    
   
 
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfile" {
//            let destinationVC = segue.destination as! EditProfileVC
//            destinationVC.initData(name: name, telefon: telefon, email: email, address: address, photo: photo as? UIImage ?? UIImage(named: "addPhoto")!)
            
            let name = profile.name
            let telefon = profile.telefon
            let email = profile.email
            let photo = profile.photo
            let profdesc = profile.profdesc
           // let isOnline = profile.isOnline
            
//             if photo == nil {
//                    photoImage.image = UIImage.init(named: "defaultImage")
//                }
//             else {
//                self.photoImage.sd_setImage(with: URL(string: self.profile.photo!), completed: nil)
//            }
            
           // let thisPhoto = self.photoImage.sd_setImage(with: userStorage, completed: nil)
            
            let destinationVC = segue.destination as! EditProfileVC
            destinationVC.initData(name: name!, telefon: telefon!, email: email!/*, address: address!*/, photo: photo!, profdesc: profdesc!/*, isOnline: isOnline! */)
        }
  }
    

}
