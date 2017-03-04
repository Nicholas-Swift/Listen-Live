//
//  SignInViewController.swift
//  ListenLive
//
//  Created by Brian Hans on 2/24/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    // MARK: - Instance Vars
    
    // MARK: - Subviews
    let loginButton = FBSDKLoginButton()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.delegate = self
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
    }
    
    // MARK: - Login Button Delegate
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        // Make sure we have access token
        guard let current = FBSDKAccessToken.current(), let accessToken = current.tokenString else {
            return
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
            self.performSegue(withIdentifier: "ToContainerViewController", sender: self)
        })
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logged out")
    }
    
}
