//
//  NetworkingErrors.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 1/14/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

enum NetworkingError: Error {
    case defaultError
    
    var description: String {
        switch self {
        default:
            return "Standart error"
        }
        
    }
}
