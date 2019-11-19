//
//  DetailViewController.swift
//  Smarket
//
//  Created by Ivan Ignatkov on 2019-03-17.
//  Copyright © 2019 TechCompetence. All rights reserved.
//

import UIKit
import Foundation

class DetailVC: UIViewController/*, UITextViewDelegate*/ {

    //var contact: Contact!
    var profile: Profile!
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userDescription: UITextView!
    @IBOutlet weak var productTel: UILabel! //@IBOutlet weak var descLbl: UITextView!
    
    
      var name = ""
      var telefon = ""
      //var email = ""
      var photo =   ""           //UIImage(named: "addPhoto")
      var profdesc = ""
   
//    override func viewWillAppear(_ animated: Bool) {
//       //super.viewDidAppear(animated)
//               userName.text = profile.name!
//               userName.font = UIFont.boldSystemFont(ofSize: 25.0)
//               userImage.image = profile.detailImage!
//              // locationLabel.text = profile.address!
//               //productDescription.text = profile.description
//               userDescription.font = UIFont(name: "Times New Roman", size: 19)
//               userDescription.text = profile.profdesc!
//              // userDescription.isEditable = false
//               userDescription.layer.cornerRadius = 10
//              // userDescription.delegate = self
//
//               productTel.text = profile.telefon!
//
//
//               let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
//               tap.numberOfTapsRequired = 1
//               productTel.isUserInteractionEnabled = true
//               productTel.addGestureRecognizer(tap)
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.text = self.name//profile.name
        userName.font = UIFont.boldSystemFont(ofSize: 25.0)
        userImage.image = profile.detailImage!
       // locationLabel.text = profile.address!
        //productDescription.text = profile.description
        userDescription.font = UIFont(name: "Times New Roman", size: 19)
        userDescription.text = profile.profdesc!
       // userDescription.isEditable = false
        userDescription.layer.cornerRadius = 10
       // userDescription.delegate = self

        productTel.text = profile.telefon!


        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        tap.numberOfTapsRequired = 1
        productTel.isUserInteractionEnabled = true
        productTel.addGestureRecognizer(tap)


    }

    func initData(profile: Profile) {
        self.profile = profile
    }
    
    
    
    
    
    @objc func tapFunction(sender: AnyObject) {
       // let numberString: String = productTel.text!
        
//        if numberString == "no telefon" || numberString.isEmpty   {
//            return
//        }
//        else if numberString.contains("0123456789#") {
//            let phoneURL = URL(string: numberString)
//            UIApplication.shared.canOpenURL(phoneURL!)
//             print("Phone number clicked")
//        }
//       // UIApplication.shared.canOpenURL(phoneURL)
//        //UIApplication.shared.canOpenURL(url)
//        //print("Phone number clicked")


        
        let phoneNumber: String = productTel.text ?? "no number"
//        let called: NSURL = NSURL(string: "tel://\(phoneNumber)")
        let options = [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly : false]

        if phoneNumber.isNumeric {
            let called: NSURL = NSURL(string: "tel://\(phoneNumber)")!
            
        UIApplication.shared.open(called as URL, options: options, completionHandler: { (success) in
            print("Open url : \(success)")
        })
            
         } else {

                return
        }
    }

    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showOnMap" {
//            //let indexPath = smarketTableView.indexPathForSelectedRow
//            //let cell = smarketTableView.cellForRow(at: indexPath!) as! MyCell
//            let locationPlace = profile.address
//            
//            
//            let destinationVC = segue.destination as! MapVC
//            destinationVC.initLocData(profile: profile)
//        }
//    }
    
    
}

extension String {
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "#", "+"]
        return Set(self).isSubset(of: nums)
    }
}
