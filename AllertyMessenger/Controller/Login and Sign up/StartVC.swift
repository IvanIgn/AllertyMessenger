//
//  ViewController.swift
//  Smarket
//
//  Created by Ivan Ignatkov on 2019-03-07.
//  Copyright © 2019 TechCompetence. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import Foundation

class StartVC: UIViewController {
    
    var profile: Profile!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil {
//            profile.isOnline = true
           // self.performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
            let mainTabBar = storyboard?.instantiateViewController(withIdentifier: "MainTabBarVC") as! MainTabBarVC
    
            mainTabBar.selectedViewController = mainTabBar.viewControllers?[0]
            
            
            
            present(mainTabBar, animated: true, completion: nil)
            
        }
    
    }
    

}

