//
//  CurrencyEndpoint.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 1/21/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

struct CurrencyQuery : Encodable {
    let json: String
}

enum CurrencyEndpoint: Endpoint {
    
    case getCurrencies
    //case test
    
    var server: Server {
        return .currencyServer
    }
    
    var path: String {
        switch self {
        case .getCurrencies:
            return "/NBUStatService/v1/statdirectory/exchange"
        }
    }
    
    var queries: Encodable? {
        switch self {
        case .getCurrencies:
            let queries = CurrencyQuery(json: "")
            return queries
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

