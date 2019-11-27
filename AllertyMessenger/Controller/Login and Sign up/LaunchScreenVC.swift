//
//  LaunchScreenVC.swift
//  AllertyMessenger
//
//  Created by Ivan Ignatkov on 2019-11-27.
//  Copyright © 2019 TechCompetence. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import Foundation
import SwiftKeychainWrapper

class LaunchScreenVC: UIViewController {

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
   // var time: Int = 3
    //var activityIndicator =   UIActivityIndicatorView.Style.large  //UIActivityIndicatorView.Style.large
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
       activityIndicator.style = UIActivityIndicatorView.Style.large
       startLoadingSpinner()
       timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(stopLoadingSpinner), userInfo: nil, repeats: false)
        
        
//         if Auth.auth().currentUser != nil {
//                   
//                    if Reachability.isConnectedToNetwork() {
//        //              var status = LoginVC.curStatus
//        //                status = true
//        //
//        //
//        //                KeychainWrapper.standard.set(status!, forKey: "status")
//        //                        updateStatus(status: true)
//                        
//                        updateStatus(setStatus: true)
//                    }
//                    
//                    
//                    let mainTabBar = storyboard?.instantiateViewController(withIdentifier: "MainTabBarVC") as! MainTabBarVC
//            
//                    mainTabBar.selectedViewController = mainTabBar.viewControllers?[0]
//                    
//                    
//                    
//                    present(mainTabBar, animated: true, completion: nil)
//                    
//                }
        
        // Do any additional setup after loading the view.
    }
    func startLoadingSpinner(){
           activityIndicator.frame = self.view.frame
           activityIndicator.center = self.view.center
          // activityIndicator.backgroundColor = .blue
           activityIndicator.alpha = 0.8
           activityIndicator.color = .white
           activityIndicator.isHidden = false
           activityIndicator.startAnimating()
           activityIndicator.hidesWhenStopped = true
           self.view.addSubview(activityIndicator)
       }
    
       @objc func stopLoadingSpinner() {
           self.activityIndicator.stopAnimating()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "StartVC")
        self.present(controller, animated: true, completion: nil)

        // Safe Present
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartVC") as? StartVC
        {
            present(vc, animated: true, completion: nil)
        }
        //performSegue(withIdentifier: "GoToStartVC", sender: Any?.self)
       }
}
    
   
