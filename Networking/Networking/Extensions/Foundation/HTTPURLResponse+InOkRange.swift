//
//  HTTPURLResponse+InOkRange.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 1/10/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    var isStatusCodeInOkRange: Bool {
        return 200...299 ~= statusCode

        // Create some method(for example: checkStatusCode) which will return case with result, for example
        // inOkRange
        // refreshToken
        //
        //        switch statusCode {
        //        case 200...299:
        //            return "OK RANGE"
        //        case 401:
        //            return "REFRESH"
        //        }
    }
}
