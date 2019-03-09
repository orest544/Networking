//
//  SettingsService.swift
//  Networking
//
//  Created by Orest Patlyka on 3/9/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation
import BrightFutures

struct SettingsService: RequestPerformable {
    
    func getProfile() -> Future<ProfileModel, NetworkingError> {
        let getProfileEndpoint = SettingsEndpoint.getProfile
        let getProfileRequest = CustomRequest(endpoint: getProfileEndpoint)
        
        return performDataTask(with: getProfileRequest,
                               logsEnable: true)
    }
    
}
