//
//  SignInViewModel.swift
//  ListenLive
//
//  Created by Brian Hans on 2/24/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class SignInViewModel {}

extension SignInViewModel {
    func login() {
        guard let token = FBSDKAccessToken.current()?.tokenString else {
            return
        }
        
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: token)
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if let error = error {
                print(error)
                return
            }
            
            
        })
    }
}
