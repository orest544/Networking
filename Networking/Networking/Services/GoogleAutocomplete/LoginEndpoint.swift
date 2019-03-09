//
//  LoginEndpoint.swift
//  Networking
//
//  Created by Orest Patlyka on 3/9/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

enum LoginEndpoint: Endpoint {
    
    case logIn
    
    var server: Server {
        return .traxServer
    }
    
    var path: String {
        switch self {
        case .logIn:
            return "/api/v1/driver/auth/login"
        }
    }
    
    var queries: Encodable? { return nil }
    
    var method: HTTPMethod {
        switch self {
        case .logIn:
            return .POST
        }
    }
    
    var isAuthTokenRequired: Bool { return false }
}
