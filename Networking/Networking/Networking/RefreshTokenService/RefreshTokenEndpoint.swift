//
//  RefreshTokenEndpoint.swift
//  Networking
//
//  Created by Orest Patlyka on 2/28/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

enum RefreshTokenEndpoint: Endpoint {
    
    case refreshToken
    
    var server: Server {
        return .afServer
    }
    
    var path: String {
        switch self {
        case .refreshToken:
            return "/api/auth/refresh"
        }
    }
    
    var queries: Encodable? { return nil }
    
    var method: HTTPMethod {
        switch self {
        case .refreshToken:
            return .GET
        }
    }
    
    var isAuthTokenRequired: Bool {
        switch self {
        case .refreshToken:
            return true
        }
    }
    
}
