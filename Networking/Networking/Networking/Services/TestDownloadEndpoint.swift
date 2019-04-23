//
//  TestDownloadEndpoint.swift
//  Networking
//
//  Created by Orest Patlyka on 3/14/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

enum TestDownloadEndpoint: Endpoint {
    
    case downloadSession
    case uploadPhoto
    
    var server: Server {
        return .afServer
    }
    
    var path: String {
        switch self {
        case .downloadSession:
            return "/downloads/hp/zt/QAydP6McSxtNUEfS.mpga"
//            return "/downloas/h/zt/QAydP6McSxtNUEfS.mpg"
        case .uploadPhoto:
            return "/api/me/avatar"
        }
    }
    
    var queries: Encodable? { return nil }
    
    var method: HTTPMethod {
        switch self {
        case .downloadSession:
            return .GET
        case .uploadPhoto:
            return .POST
        }
    }
    
    var isAuthTokenRequired: Bool {
        switch self {
        case .downloadSession:
            return true
        case .uploadPhoto:
            return true
        }
    }

}
