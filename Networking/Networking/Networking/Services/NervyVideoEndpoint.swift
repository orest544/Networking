//
//  NervyVideoEndpoint.swift
//  Nervy
//
//  Created by Orest Patlyka on 5/31/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

enum NervyVideoEndpoint: Endpoint {
    
    case uploadVideo
    
    var server: Server {
        return .nervy
    }
    
    var path: String {
        switch self {
        case .uploadVideo:
            return "/api/v1/videos"
        }
    }
    
    var queries: Encodable? {
        return nil
    }
    
    var method: HTTPMethod {
        switch self {
        case .uploadVideo:
            return .POST
        }
    }
    
    var isAuthTokenRequired: Bool {
        return false
    }

}
