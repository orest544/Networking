//
//  CurrencyModel.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 1/10/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

typealias Currencies = [Currency]

struct Currency: Codable {
    var id: Int
    var description: String
    var exchangeRate: Double
    var abbreviation: String
    var exchangeDateStr: String
    
    enum CodingKeys: String, CodingKey {
        case id = "r030"
        case description = "txt"
        case exchangeRate = "rate"
        case abbreviation = "cc"
        case exchangeDateStr = "exchangedate"
    }
}

