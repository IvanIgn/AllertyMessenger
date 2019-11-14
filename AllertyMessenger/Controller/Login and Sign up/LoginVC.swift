//
//  LoginViewController.swift
//  Smarket
//
//  Created by Ivan Ignatkov on 2019-03-07.
//  Copyright © 2019 TechCompetence. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class LoginVC: UIViewController, UITextFieldDelegate {

      var db : Firestore!
      var auth : Auth!
      var curUserUID: String!
    
    override func viewDidLoad() {
               super.viewDidLoad()
        
        db = Firestore.firestore()
        auth = Auth.auth()

        let retrievedEmail: String? = KeychainWrapper.standard.string(forKey: "savedEmail")
        let retrievedPassword: String? = KeychainWrapper.standard.string(forKey: "savedPassword")
        
        email.text = retrievedEmail
        password.text = retrievedPassword
        
        
        email.delegate = self
        password.delegate = self
               
        self.hideKeyboardWhenTappedAround()
           // Do any additional setup after loading the view.
       }
    
    
    
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
   
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    @IBAction func forgotButtonClicked(_ sender: Any) {
        auth.sendPasswordReset(withEmail: email.text!) { error in
            DispatchQueue.main.async {
                if self.email.text?.isEmpty==true || error != nil {
                    let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetFailedAlert, animated: true, completion: nil)
                }
                if error == nil && self.email.text?.isEmpty==false{
                    let resetEmailAlertSent = UIAlertController(title: "Reset Email Sent", message: "Reset email has been sent to your login email, please follow the instructions in the mail to reset your password", preferredStyle: .alert)
                    resetEmailAlertSent.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetEmailAlertSent, animated: true, completion: nil)
                    
                    
                }
            }
        }
    }
    
    
    
    @IBAction func loginAction(_ sender: Any) {
        let alertTitle1 = NSLocalizedString("Error", comment: "")
        let alertText1 = NSLocalizedString("You have entered an incorrect username or password. Please enter the correct information and try again.", comment: "")
         let uuid = UUID().uuidString.lowercased()
        
       auth.signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            if error == nil{
               // self.performSegue(withIdentifier: "loginToHome", sender: self)
                if (self.email.text != "Type your email" && self.email.text != "Type your password") {
                KeychainWrapper.standard.set(self.email.text!, forKey: "savedEmail")
                KeychainWrapper.standard.set(self.password.text!, forKey: "savedPassword")
                    print("USER: \(uuid) HAS LOGGED IN")
                    
//                    self.curUserUID = self.auth.currentUser?.uid
//                    print("Current users uid is: \(String(self.curUserUID))")
                    
            if let user = self.auth.currentUser {
                let mainTabBar = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarVC") as! MainTabBarVC
                mainTabBar.selectedViewController = mainTabBar.viewControllers?[0]
                self.present(mainTabBar, animated: true, completion: nil)
                self.curUserUID = self.auth.currentUser?.uid
                print("Current users uid is: \(String(self.curUserUID))")
                    }
               }
                
//                let mainTabBar = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarVC") as! MainTabBarVC
//
//                        mainTabBar.selectedViewController = mainTabBar.viewControllers?[0]
//
//
//                self.present(mainTabBar, animated: true, completion: nil)
            }
            else{
//                let alertController = UIAlertController(title: "Error", message: "You have entered an incorrect username or password. Please enter the correct information and try again."/*error?.localizedDescription*/, preferredStyle: .alert)
//                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//
//                alertController.addAction(defaultAction)
//                self.present(alertController, animated: true, completion: nil)
                
                let alertController = UIAlertController(title: alertTitle1, message: alertText1
                    /*error?.localizedDescription*/, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    
       
    


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      email.resignFirstResponder()
      password.resignFirstResponder()
        return true;
    }
    
    //textfield func for the touch on BG
//    func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//      email.resignFirstResponder()
//       password.resignFirstResponder()
//       self.view.endEditing(true)
//
//     }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
