//
//  AireFrescoTestEndpoint.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 1/22/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

enum AireFrescoEndpoint: Endpoint {
    
    case sighUp
    case sighIn
    
    var server: Server {
        return .afServer
    }
    
    var path: String {
        switch self {
        case .sighUp:
            return "/api/auth/register"
        case .sighIn:
            return "/api/auth/login"
        }
    }
    
    var queries: Encodable? {
        switch self {
        default:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .sighUp:
            return .POST
        case .sighIn:
            return .POST
        }
    }
    
    var isAuthTokenRequired: Bool {
        switch self {
        default:
            return false
        }
    }

}
