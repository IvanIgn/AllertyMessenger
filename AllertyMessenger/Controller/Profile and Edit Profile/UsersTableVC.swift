//
//  SmarketTableViewController.swift
//  Smarket
//
//  Created by Ivan Ignatkov on 2019-03-17.
//  Copyright © 2019 TechCompetence. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class UsersTableVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var smarketTableView: UITableView!
    @IBOutlet weak var smSearchBar: UISearchBar!
    
  //  var idForRow = 0
 //   var tapGesture = UITapGestureRecognizer(target: self, action: #selector(lblTapped))
    
    var userArray = [Profile]()               // main array   //Contact
    var curUserArray = [Profile]()          // search array  // Contact
    
    var advertCollectionRef: CollectionReference!
    var advertListener: ListenerRegistration!
    var db: Firestore!
    let storage = Storage.storage().reference(forURL: "gs://allertymessenger.appspot.com")
    
    var searching = false
    
    
    var logVC = LoginVC()
    var currentUser: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
         
        db = Firestore.firestore()
        smarketTableView.dataSource = self
        smarketTableView.delegate = self
        smSearchBar.delegate = self
        smSearchBar.placeholder = "Search user by name"
        advertCollectionRef = Firestore.firestore().collection("users")
        //
       // self.smarketTableView.register(UITableViewCell.self, forCellReuseIdentifier: "myContactCell")
       

           //smarketTableView.reloadData()
       // loadUsersData()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       loadUsersData  {
        self.smarketTableView.reloadData()
        }
       // upgradeUsersData()
//        smarketTableView.reloadData()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        userArray.removeAll()
        
        
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {

       return 1
   }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
           return curUserArray.count
        } else {
            return userArray.count
        }
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = smarketTableView.dequeueReusableCell(withIdentifier: "myContactCell") as? ContactCell else {return UITableViewCell()}
     /////
//       tapGesture = UITapGestureRecognizer(target: self, action: #selector(lblTapped))
//      // tapGesture.minimumPressDuration = 1
//       tapGesture.numberOfTapsRequired = 1
//       cell.productImage.addGestureRecognizer(tapGesture)
//       cell.productImage.isUserInteractionEnabled = true
        ///////
    
               // self.performSegue(withIdentifier: "DetailVC", sender:  cell )
        
        if searching {
            let curAdvertItem = curUserArray[indexPath.row]
           // cell.textLabel?.text = curSmarkethArray[indexPath.row] as? String
            cell.configureCell(profile: curAdvertItem)  // contact
        } else {
            let advertItem = userArray[indexPath.row]
            cell.configureCell(profile: advertItem)  // contact
        }
//       
//        cell.cellDelegate = (self as! TableViewNew)
//        cell.index = indexPath
//        
        return cell
    }
    
    
    
    
    
//    @objc func lblTapped(sender: UIImageView) {
//               print("The image is tapped)")
//        self.performSegue(withIdentifier: "DetailVC", sender: sender )
//
//
//           }
    

    
//    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
//
//    }

//    @objc func segue(sender: UIButton) {
//           self.performSegue(withIdentifier: "goNextPage", sender: sender)
//
//       }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true )
//
//          let cell = tableView.cellForRow(at: indexPath) as! ContactCell
//         self.performSegue(withIdentifier: "DetailVC", sender:  cell )


//        let cell = tableView.cellForRow(at: indexPath) as! ContactCell
//         tapGesture = UITapGestureRecognizer(target: self, action: #selector(lblTapped))
//       // tapGesture.minimumPressDuration = 1
//        tapGesture.numberOfTapsRequired = 1
//        cell.productImage.addGestureRecognizer(tapGesture)
//        cell.productImage.isUserInteractionEnabled = true

    }

    
    
    
    
    /// upgrades data properly  and sorts users by timestamp ///
    func loadUsersData(completed: @escaping () -> ()) {
        advertListener = db.collection("users").order(by: "timestamp", descending: true).addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("Error getting the snapshot listener \(error?.localizedDescription)")
                return completed()
            }
            self.userArray = []
            
            for document in querySnapshot!.documents {
                if (document["id"] as? String  != Auth.auth().currentUser?.uid)
                {
                    let profile = Profile(snapshot: document)
                    self.userArray.append(profile)
                }
            }
            completed()
        }
    }
    
   
    
      /////////////////////////////////////////////////////////////////////////////////////////////
    
//    func upgradeUsersData() {
//        advertListener = advertCollectionRef.order(by: "timestamp", descending: true).addSnapshotListener { (snapshot, error) in
//            if let error = error {
//                print("Error getting documents: \(error.localizedDescription)")
//            } else {
//                guard let snapshot = snapshot else { return }
//
//                self.userArray.removeAll()
//                for document in snapshot.documents {
//                    let profile = Profile(snapshot: document)  // contact = Contact
//                    self.userArray.append(profile)  // (contact)
//                }
//                self.smarketTableView.reloadData()
//                }
//        }
//
//    }
    
      /////////////////////////////////////////////////////////////////////////////////////////////
    
    /////  TESTING TO GET USERS IN TABLE VIEW ///////  IT WORKS
//  func loadUsersData() {
//    advertCollectionRef.order(by: "timestamp", descending: true).getDocuments() { (snapshot, error) in
//          if let err = error {
//              debugPrint("Error fetching docs: \(err)")
//          } else {
//            guard let  snap = snapshot else {return}
//
//
//            for document in snap.documents {
//
//
//
//                    let data = document.data()
//
//                ////  testing to exclude current user from database //// it  works
//                if (data["id"] as? String  != Auth.auth().currentUser?.uid) {
//
//                    let address = data["address"] as? String ?? "no address"
//                    let email = data["email"] as? String ?? "no email"
//                    let name = data["name"] as? String ?? "no name"
//                    let photo = data["photo"] as? String ?? ""
//                    let telefon = data["telefon"] as? String ?? "no telefon"
//                    let documentId = document.documentID
//
//                    let newUserArrayData = Profile(name: name, telefon: telefon, email: email, address: address, photo: photo)
//
//                    self.userArray.append(newUserArrayData)
//                }
//            }
//
//
//            DispatchQueue.main.async {
//            self.smarketTableView.reloadData()
//            }
//         }
//    }
//    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailVC" {
            let indexPath = smarketTableView.indexPathForSelectedRow
            let cell = smarketTableView.cellForRow(at: indexPath!) as! ContactCell
            
             //smarketTableView.allowsSelection = true
            let profile = userArray[indexPath!.row]   // contact
            profile.detailImage = cell.productImage.image
           
            
            
      /////// TESTING ///////
          

//            let name = profile.name
//            let telefon = profile.telefon
//           // let email = profile.email
//            //let address = profile.address
//            let photo = profile.photo
//            let profdesc = profile.profdesc
            
    /////////       ///////////
           if profile.detailImage == nil {
                cell.productImage.image = UIImage.init(named: "defaultImage")
            }

            let destinationVC = segue.destination as! DetailVC
            destinationVC.initData(profile: profile)
            
           // destinationVC.initData(name: name!, telefon: telefon!/*, email: email!*/, photo: photo!, profdesc: profdesc!)
            
        }
    }
    
}



extension UsersTableVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty
            else
        {
            curUserArray = userArray
            smarketTableView.reloadData()
            return
            
        }
//        smSearchArray = smarketArray.filter({(String($0.productName.lowercased().prefix(searchText.count))) as String ==  searchText.lowercased()})
        
        curUserArray = userArray.filter({ profile -> Bool in   // contact
           profile.name.lowercased().contains(searchText.lowercased())  // contact
        })
        searching = true
        smarketTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        smarketTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.view.endEditing(true)
    }
    

}

//extension UsersTableVC: TableViewNew {
//    func onClickCell(index: Int) {
//        print("\(index) IS CLICKED!!!")
//
//        performSegue(withIdentifier: "DetailVC", sender: ContactCell?.self)
//    }
//}
