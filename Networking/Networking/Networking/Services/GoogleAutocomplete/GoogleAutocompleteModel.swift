//
//  GoogleAutocompleteModel.swift
//  Networking
//
//  Created by Orest Patlyka on 2/26/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

struct GoogleAutocompleteModel: Codable {
    let predictions: [Prediction]
    let status: String
}

struct Prediction: Codable {
    let description, id: String
    let matchedSubstrings: [MatchedSubstring]?
    // Be carefull with "Id"
    let placeId, reference: String
    let structuredFormatting: StructuredFormatting?
    let terms: [Term]?
    let types: [String]?
}

struct MatchedSubstring: Codable {
    let length, offset: Int?
}

struct StructuredFormatting: Codable {
    let mainText: String?
    let mainTextMatchedSubstrings: [MatchedSubstring]?
    let secondaryText: String?
}

struct Term: Codable {
    let offset: Int?
    let value: String?
}
