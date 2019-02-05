//
//  CurrencyEndpoint.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 1/21/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

enum CurrencyEndpoint: Endpoint {
    
    case getCurrencies
    //case test
    
    var server: Server {
        return .currencyServer
    }
    
    var path: String {
        switch self {
        case .getCurrencies:
            return "/NBUStatService/v1/statdirectory/exchange?json"
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
        case .getCurrencies:
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

