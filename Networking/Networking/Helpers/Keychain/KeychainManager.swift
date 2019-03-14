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
            optimizedPrint("Saving new token into keychain: \(token)")
            return true
        } catch {
            optimizedPrint("Error updating keychain - \(error)")
            return false
        }
    }
    
    static func readTokenFromKeychain(_ id: Int) -> String? {
        do {
            let tokenItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                 account: "\(id)")
            let keychainToken = try tokenItem.readPassword()
            optimizedPrint("Reading token from keychain: \(keychainToken)")
            return keychainToken
        } catch {
            optimizedPrint("Error reading token from keychain - \(error)")
            return nil
        }
    }

}
