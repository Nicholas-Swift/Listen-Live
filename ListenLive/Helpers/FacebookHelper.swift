//
//  FacebookHelper.swift
//  ListenLive
//
//  Created by Jake on 2/24/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class FacebookHelper {
    
    // MARK: - Class Vars
    
    static let loginManager = FBSDKLoginManager()
    
    // MARK: - Facebook Login
    
    class func logIn(from viewController: UIViewController, handler: FBSDKLoginKit.FBSDKLoginManagerRequestTokenHandler!) {
        let permissions = ["public_profile", "email", "user_friends"]
        FacebookHelper.loginManager.logIn(withReadPermissions: permissions, from: viewController, handler: handler)
    }
    
    class func logOut() {
        loginManager.logOut()
    }
    
    // MARK: - User Info
    
    class func fetchUserInfo(with handler: @escaping ([String : String]?, Error?) -> Void) {
        let params = ["fields" : "email,picture,first_name,last_name"]
        let path = "me"
        
        FBSDKGraphRequest(graphPath: path, parameters: params)
            .start { (conn, result, error) in
                if let error = error {
                    handler(nil, error)
                } else if let userDict = result as? NSDictionary {
                    var userInfo = [String : String]()
                    if let email = userDict["email"] as? String {
                        userInfo["email"] = email
                    }
                    
                    if let picture = userDict["picture"] as? NSDictionary,
                        let pictureData = picture["data"] as? NSDictionary,
                        let pictureURL = pictureData["url"] as? String {
                        userInfo["profile_picture_url"] = pictureURL
                    }
                    
                    if let firstName = userDict["first_name"] as? String {
                        userInfo["first_name"] = firstName
                    }
                    
                    if let lastName = userDict["last_name"] as? String {
                        userInfo["last_name"] = lastName
                    }
                    
                    handler(userInfo, nil)
                } else {
                    assertionFailure("Error: no user info provided from Facebook in fetchUserInfo(with:)")
                    handler(nil, nil)
                }
        }
    }

    
}
