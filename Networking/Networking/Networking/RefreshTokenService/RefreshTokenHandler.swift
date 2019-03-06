//
//  RefreshTokenHandler.swift
//  Networking
//
//  Created by Orest Patlyka on 2/28/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

enum RefreshTokenHandler {
    
    static func handleFailure() {
        /// Make your logOut or smth else if refresh is failures
        // TODO: mb add functionality for deleting token from key chain
        DataTaskDetailsStorage.detailsDict.removeAll()
        print("Handle failure of refresh token, removingAll in DataTasksStorage.tempTasks")
    }

    static func handleSuccess(with newToken: String) -> Bool {
        // TODO: Inplement logic with userID! and improve code
        print("Handle success refresh token")
        let userID = UserDefaults.standard.integer(forKey: "userID")
        if KeychainManager.saveTokenToKeychain(userID, token: newToken) == false {
            handleFailure()
            return false
        } else {
            return true
        }
    }
    
}
