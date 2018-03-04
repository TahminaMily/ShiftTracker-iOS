//
//  LoginManager.swift
//  ShiftTracker
//
//  Created by Tahmina Khanam on 4/3/18.
//  Copyright © 2018 Deputy. All rights reserved.
//

import Foundation

class AuthManager {
    static let shared = AuthManager()
    
    private enum Constants {
        static let usernameKey = "username"
    }
    
    func login(username: String) -> Bool {
        UserDefaults.standard.setValue(username, forKey: Constants.usernameKey)
        return true
    }
    
    var loggedInUsername: String? {
        return UserDefaults.standard.string(forKey: Constants.usernameKey)
    }
    
    var isLoggedIn: Bool {
        return loggedInUsername != nil
    }
}
