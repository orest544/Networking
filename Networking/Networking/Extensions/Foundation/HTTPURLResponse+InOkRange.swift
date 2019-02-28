//
//  HTTPURLResponse+InOkRange.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 1/10/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

enum StatusCodeResult {
    case good
    case bad
    case refresh
}

fileprivate enum StatusCodeValue {
    static let goodRange = 200...299
    
    // change for your value if needed
    static let refreshCode = 401
}

extension HTTPURLResponse {
    var isStatusCodeInOkRange: Bool {
        return 200...299 ~= statusCode
    }
    
    func validateStatusCode() -> StatusCodeResult {
        switch statusCode {
        case StatusCodeValue.goodRange:
            return .good
        case StatusCodeValue.refreshCode:
            return .refresh
        default:
            return .bad
        }
    }

}
