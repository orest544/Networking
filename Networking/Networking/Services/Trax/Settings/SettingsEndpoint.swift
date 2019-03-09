//
//  SettingsEndpoint.swift
//  Networking
//
//  Created by Orest Patlyka on 3/9/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

enum SettingsEndpoint: Endpoint {
    
    case getProfile
    
    var server: Server {
        return .traxServer
    }
    
    var path: String {
        switch self {
        case .getProfile:
            return "/api/v1/driver/settings/profile"
        }
    }
    
    var queries: Encodable? { return nil }
    
    var method: HTTPMethod {
        switch self {
        case .getProfile:
            return .GET
        }
    }
    
    var isAuthTokenRequired: Bool {
        switch self {
        case .getProfile:
            return true
        }
    }

}
