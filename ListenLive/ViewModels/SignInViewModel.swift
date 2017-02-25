//
//  SignInViewModel.swift
//  ListenLive
//
//  Created by Jake on 2/24/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import Firebase

protocol SignInViewModelDelegate: class {
    func alertController(for error: Error?, message: String)
}

class SignInViewModel {
    // MARK: - Instance Vars
    weak var delegate: SignInViewModelDelegate?
    
    func loginToFacebook(from viewController: UIViewController) {
        FacebookHelper.logIn(from: viewController) {
            (result: FBSDKLoginManagerLoginResult?, error: Error?) in
            if let error = error {
                let errorMessage = "Error signing into Facebook: \(error.localizedDescription)"
                self.delegate?.alertController(for: error, message: errorMessage)
            } else if let result = result, !result.isCancelled {
                print("success logging in with facebook")
                    
                }
        }
    }

}
