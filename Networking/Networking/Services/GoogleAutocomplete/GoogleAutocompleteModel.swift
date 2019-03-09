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
    let placeID, reference: String
    let structuredFormatting: StructuredFormatting?
    let terms: [Term]?
    let types: [String]?
    
    enum CodingKeys: String, CodingKey {
        case description, id
        case matchedSubstrings = "matched_substrings"
        case placeID = "place_id"
        case reference
        case structuredFormatting = "structured_formatting"
        case terms, types
    }
}

struct MatchedSubstring: Codable {
    let length, offset: Int?
}

struct StructuredFormatting: Codable {
    let mainText: String?
    let mainTextMatchedSubstrings: [MatchedSubstring]?
    let secondaryText: String?
    
    enum CodingKeys: String, CodingKey {
        case mainText = "main_text"
        case mainTextMatchedSubstrings = "main_text_matched_substrings"
        case secondaryText = "secondary_text"
    }
}

struct Term: Codable {
    let offset: Int?
    let value: String?
}
