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

class SignInViewController: UIViewController {
    
    // MARK: - Instance Vars
    
    // MARK: - Subviews
    let loginButton = FBSDKLoginButton()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
    }
    
}
