//
//  AppDelegate.swift
//  AllertyMessenger
//
//  Created by Ivan Ignatkov on 2019-11-01.
//  Copyright © 2019 TechCompetence. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseFirestore
import SwiftKeychainWrapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var profile: Profile!
  var navigationBarAppearace = UINavigationBar.appearance()
  var splashView = UIActivityIndicatorView()
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        //updateStatus(setStatus: true)
        
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            
          //  updateStatus(setStatus: true)
//            //loadStatus(status: true)
          // updateStatus(setStatus: true)
//            AppDelegate.Status = true
//            UserDefaults.standard.set(AppDelegate.Status, forKey: "status")
                    
        }else{
            print("Internet Connection not Available!")
         // updateStatus(setStatus: false)
        }
   
        navigationBarAppearace.barTintColor = UIColor(red: 72/255, green: 44/255, blue: 112/255, alpha: 1)
        
       
        return true
        
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "AllertyMessenger")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
       //loadStatus(status: false)
        //KeychainWrapper.standard.removeObject(forKey: "status")
        //if !Reachability.isConnectedToNetwork() {
        DispatchQueue.global().sync {
             updateStatus(setStatus: true)
        }
       // updateStatus(setStatus: true)  //  true
        
        //}
    }
        


}

