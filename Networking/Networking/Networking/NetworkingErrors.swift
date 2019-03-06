//
//  NetworkingErrors.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 1/14/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

enum NetworkingError: Error {
    case defaultError
    case badData
    case responseError(String)
    case canceled
    
    var description: String {
        switch self {
        case .defaultError:
            return "Standart error"
        case .badData:
            return "No data or response"
        case .responseError(let errorText):
            return errorText
        case .canceled:
            return "canceled"
        }
        
    }
}
