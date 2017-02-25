//
//  SignInViewController.swift
//  ListenLive
//
//  Created by Jake on 2/24/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class SignInViewController: UIViewController {
    
    fileprivate let viewModel = SignInViewModel()
    
    let facebookButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(facebookButton)
        facebookButton.addTarget(self, action: #selector(facebookButtonTapped(_:)), for: .touchUpInside)
        facebookButton.delegate = self
        
        setupConstraints()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if FBSDKAccessToken.current() != nil {
            performSegue(withIdentifier: Constants.Storyboard.Segue.toSearchViewController, sender: self)
        }
    }
    
    func facebookButtonTapped(_ sender: Any) {
        viewModel.loginToFacebook(from: self)
    }
}

extension SignInViewController: FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        } else if let result = result, !result.isCancelled {
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        FacebookHelper.logOut()
    }
            
}

// MARK: - Autolayout
extension SignInViewController {
    
    func setupConstraints() {
        let top = NSLayoutConstraint(item: facebookButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 250)
        let centerX = NSLayoutConstraint(item: facebookButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([top, centerX])
    }
}
