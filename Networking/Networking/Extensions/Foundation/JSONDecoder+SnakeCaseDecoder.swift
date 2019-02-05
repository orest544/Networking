//
//  JSONDecoder+SnakeCaseDecoder.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 1/30/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

extension JSONDecoder {
    static func snakeCaseDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    }
}
