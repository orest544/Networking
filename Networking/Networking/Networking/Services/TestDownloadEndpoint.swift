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
    
    var server: Server {
        return .afServer
    }
    
    var path: String {
        switch self {
        case .downloadSession:
            return "/downloads/hp/zt/QAydP6McSxtNUEfS.mpga"
        }
    }
    
    var queries: Encodable? { return nil }
    
    var method: HTTPMethod {
        switch self {
        case .downloadSession:
            return .GET
        }
    }
    
    var isAuthTokenRequired: Bool {
        switch self {
        case .downloadSession:
            return true
        }
    }

}
