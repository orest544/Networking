//
//  LoginService.swift
//  Networking
//
//  Created by Orest Patlyka on 3/9/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation
import BrightFutures

struct LoginService: RequestPerformable {
    
    func logIn(with logInBody: LoginCredentialsModel) -> Future<TraxUserModel, NetworkingError> {
        let logInEndpoint = LoginEndpoint.logIn
        let logInRequest = CustomRequest(endpoint: logInEndpoint,
                                         body: logInBody)
        
        return performDataTask(with: logInRequest,
                               logsEnable: true)
    }
    
}
