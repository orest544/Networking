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
    
    // TODO: Refactore it
    static func saveTokenToKeychain(_ id: Int? = nil,
                                    idString: String? = nil,
                                    token: String) -> Bool {
        do {
            let tokenItems = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                  account: idString ?? String(id ?? -1))
            try tokenItems.savePassword(token)
            return true
        } catch {
            print("Error updating keychain - \(error)")
            return false
        }
    }
    
    static func readTokenFromKeychain(id: Int? = nil, idString: String? = nil) -> String? {
        do {
            let tokenItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                 account: idString ?? String(id ?? -1))
            let keychainToken = try tokenItem.readPassword()
            return keychainToken
        } catch {
            print("Error reading token from keychain - \(error)")
            return nil
        }
    }

}
