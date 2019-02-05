//
//  Encodable+PerformDictionary.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 1/21/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
    
    var dictionaryForQueries: [String: String] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder.snakeCaseEncoder().encode(self))) as? [String: String] ?? [:]
    }
    
    func myData() throws -> Data {
        do {
            let encoder = JSONEncoder.snakeCaseEncoder()
            return try encoder.encode(self)
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }

}
