//
//  AFWithQueriesEndpoint.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 1/29/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

enum AFWithQueriesEndpoint: Endpoint {
    
    case getPaymentPlans(queries: Encodable)
    
    var server: Server {
        return .afServer
    }
    
    var path: String {
        switch self {
        case .getPaymentPlans:
            return "/api/payments/payment-plans"
        }
    }
    
    var queries: Encodable? {
        switch self {
        case .getPaymentPlans(let queries):
            return queries
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getPaymentPlans:
            return .GET
        }
    }
    
    var isAuthTokenRequired: Bool {
        switch self {
        case .getPaymentPlans:
            return true
        }
    }

}
