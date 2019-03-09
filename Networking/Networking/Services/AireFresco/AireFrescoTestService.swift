//
//  AireFrescoTestService.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 1/22/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation
import BrightFutures

struct AireFrescoTestService: RequestPerformable {
    
    func sighUp(with userBody: SignUpBody) -> Future<UserModel, NetworkingError> {
        
        let sighUpRequest = CustomRequest(endpoint: AireFrescoEndpoint.sighUp,
                                          body: userBody)
        return performDataTask(with: sighUpRequest)
    }
    
    
    func signIn(with credentials: SignInBody) -> Future<UserModel, NetworkingError> {
        
        let signInRequest = CustomRequest(endpoint: AireFrescoEndpoint.sighIn,
                                          body: credentials)
        return performDataTask(with: signInRequest)
    }
    
    // Empty Response
    func changePassword(with newPasswordBody: ChangePasswordBody) -> Future<EmptyResult, NetworkingError> {
        
        let changePasswordRequest = CustomRequest(endpoint: AireFrescoEndpoint.changePassword,
                                                  body: newPasswordBody)
        
        return performDataTask(with: changePasswordRequest,
                               logsEnable: true)
    }
    
}
