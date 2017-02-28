//
//  AppDelegate.swift
//  ListenLive
//
//  Created by Nicholas Swift on 2/24/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Set up Firebase
        FIRApp.configure()
        
        // Set up Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Is user already logged in?
        if let current = FBSDKAccessToken.current(), let _ = current.tokenString {
            
            // Set ContainerViewController
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "ContainerViewController")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            
            return true
        }
        
        // Not logged in, instantiate sign in view controller
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        // Handle Facebook
        FBSDKAppEvents.activateApp()
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        // Handle Facebook
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        
        // Error
        if url.absoluteString.contains("#error") { // WORST ERROR HANDLING IN THE WORLD?
            return handled
        }
        
        // Make sure we have access token
        guard let current = FBSDKAccessToken.current(), let accessToken = current.tokenString else {
            return handled
        }
        
        // Firebase configuration
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken)
        FIRAuth.auth()?.signIn(with: credential, completion: { (user: FIRUser?, error: Error?) in
            
            // Error
            if let error = error {
                print("FUCK ERROR \(error)")
                return
            }
            
            // Successfully went through, move to main view
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "ContainerViewController")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            
        })
        
        return handled
    }


}

