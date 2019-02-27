//
//  GoogleAutocompleteEndpoint.swift
//  Networking
//
//  Created by Orest Patlyka on 2/26/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

enum GoogleAutocompleteEndpoint: Endpoint {
    
    case getAutocomplete(queries: Encodable)
    
    var server: Server {
        return .googleAPIsServer
    }
    
    var path: String {
        switch self {
        case .getAutocomplete:
            return "/maps/api/place/autocomplete/json"
        }
    }
    
    var queries: Encodable? {
        switch self {
        case .getAutocomplete(let queries):
            return queries
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAutocomplete:
            return .GET
        }
    }
    
    var isAuthTokenRequired: Bool {
        switch self {
        default:
            return false
        }
    }

}
