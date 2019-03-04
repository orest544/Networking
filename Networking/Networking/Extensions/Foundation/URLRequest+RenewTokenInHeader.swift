//
//  URLRequest+RenewTokenInHeader.swift
//  Networking
//
//  Created by Orest Patlyka on 3/4/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

extension URLRequest {
    // TODO: mb remove mutating
    mutating func renewToken() {
        let userID = UserDefaults.standard.integer(forKey: "userID")
        let token = KeychainManager.readTokenFromKeychain(userID)
        
        setValue(token, forHTTPHeaderField: "Authorization")
    }
}
