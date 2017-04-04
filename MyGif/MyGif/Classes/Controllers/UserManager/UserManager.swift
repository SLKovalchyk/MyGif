//
//  UserManager.swift
//  MyGif
//
//  Created by Sergey Kovalchyk on 03.04.17.
//  Copyright © 2017 Sergey Kovalchyk. All rights reserved.
//

import UIKit

class UserManager: NSObject {

    private override init() {

    }
    static let sharedManager : UserManager = UserManager(); // init Singltone

    static let kCurrentUserKey = "currentUserKey"
    static let kTokenKey = "currentUserKey"

    //make setter and getter for current user token
    var token : String {
        set (newValue) {
            UserDefaults.standard.set(newValue, forKey: UserManager.kTokenKey);
            UserDefaults.standard.synchronize();
        }
        get {
            return UserDefaults.standard.value(forKey: UserManager.kTokenKey) as! String;
        }
    }
    
    // store current user to NSUserDefaults
    func storeCurrentUser (name : String,
                           email : String,
                           avatarURL : String) {
        let userParams = ["name" : name,
                          "email" : email,
                          "avatarURL" : avatarURL];

        UserDefaults.standard.set(userParams, forKey: UserManager.kCurrentUserKey);
        UserDefaults.standard.synchronize();
    }
}
