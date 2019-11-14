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

class MessagesTableVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var smarketTableView: UITableView!
    @IBOutlet weak var smSearchBar: UISearchBar!
    
    
    var userArray = [Profile]()               // main array   //Contact
    var curUserArray = [Profile]()          // search array  // Contact
    
    var advertCollectionRef: CollectionReference!
    var advertListener: ListenerRegistration!
   // var db: Firestore!
    let storage = Storage.storage().reference(forURL: "gs://allertymessenger.appspot.com")
    
    var searching = false
    
    
    var logVC = LoginVC()
    var currentUser: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // smarketArray.removeAll()
       // let p = Profile(name: "David", telefon: "987", email: "sadf", address: "asdf", photo: "sDAF")
        
       //smarketArray.append(p)
         
         //db = Firestore.firestore()
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
       loadUsersData()
        //smarketTableView.reloadData()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        userArray.removeAll()
        
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
        
        if searching {
            let curAdvertItem = curUserArray[indexPath.row]
           // cell.textLabel?.text = curSmarkethArray[indexPath.row] as? String
            cell.configureCell(profile: curAdvertItem)  // contact
        } else {
            let advertItem = userArray[indexPath.row]
            cell.configureCell(profile: advertItem)  // contact
        }
        
        return cell
    }
    
//    func loadUsersData() {
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
//
//
//        }
//
//    }
    
    /////  TESTING TO GET USERS IN TABLE VIEW ///////  IT WORKS
  func loadUsersData() {
    advertCollectionRef.order(by: "timestamp", descending: true).getDocuments() { (snapshot, error) in
          if let err = error {
              debugPrint("Error fetching docs: \(err)")
          } else {
            guard let  snap = snapshot else {return}
            
            
            for document in snap.documents {
        
                    let data = document.data()
                    let address = data["address"] as? String ?? "no address"
                    let email = data["email"] as? String ?? "no email"
                    let name = data["name"] as? String ?? "no name"
                    let photo = data["photo"] as? String ?? ""
                    let telefon = data["telefon"] as? String ?? "no telefon"
                    let documentId = document.documentID
                    
                    let newUserArrayData = Profile(name: name, telefon: telefon, email: email, address: address, photo: photo)
        
                    self.userArray.append(newUserArrayData)
                                                                   
            }
            DispatchQueue.main.async {
            self.smarketTableView.reloadData()
            }
         }
    }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailVC" {
            let indexPath = smarketTableView.indexPathForSelectedRow
            let cell = smarketTableView.cellForRow(at: indexPath!) as! ContactCell
            let profile = userArray[indexPath!.row]   // contact
            profile.detailImage = cell.productImage.image
           // let name = profile.name

//            let name = profile.name
//            let telefon = profile.telefon
//            let email = profile.email
//            let address = profile.address
//            //let thisPhoto = profile.photo
//            //let thisPhoto = profile.photo
//            let photo = profile.photo
            
            
//           if profile.detailImage == nil {
//                cell.productImage.image = UIImage.init(named: "defaultImage")
//            }

            let destinationVC = segue.destination as! DetailVC
            destinationVC.initData(profile: profile)
        }
    }
    
}



extension MessagesTableVC: UISearchBarDelegate {
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

