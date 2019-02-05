//
//  KeychainManager.swift
//  AireFresco
//
//  Created by mac on 6/20/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation

class KeychainManager {
//    var tokenItems: [KeychainPasswordItem] = []
    
    static func saveTokenToKeychain(_ id: Int, token: String) -> Bool {
        do {
            let tokenItems = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                  account: "\(id)")
            try tokenItems.savePassword(token)
            return true
        } catch {
            print("Error updating keychain - \(error)")
            return false
        }
    }
    
    static func readTokenFromKeychain(_ id: Int) -> String? {
        do {
            let tokenItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                 account: "\(id)")
            let keychainToken = try tokenItem.readPassword()
            return keychainToken
        } catch {
            print("Error reading token from keychain - \(error)")
            return nil
        }
    }

}
