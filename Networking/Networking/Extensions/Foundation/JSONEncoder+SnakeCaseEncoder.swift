//
//  JSONEncoder+SnakeCaseEncoder.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 1/25/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

extension JSONEncoder {
    static func snakeCaseEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        return encoder
    }
}
