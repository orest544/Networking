//
//  URLConstructable.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 1/21/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

protocol URLConstructable {
    var server: Server { get }
    
    var path: String { get }
    var queries: Encodable? { get }
    
    func asURL() -> URL
}

protocol RequestContructable {
    var method: HTTPMethod { get }
    var isAuthTokenRequired: Bool { get }
}

extension URLConstructable {

    func asURL() -> URL {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = server.scheme.rawValue
        urlComponents.host = server.host
        
        // Adding path
        urlComponents.path = path
        
        // Adding query if needed
        if let queries = queries {
            urlComponents.queryItems = createQueryItems(queries)
        }

        let finalURL = urlComponents.url
        assert(finalURL != nil, "Can't create URL, please check your endpoint enum")
        
        return finalURL!
    }
    
    private func createQueryItems(_ queries: Encodable) -> [URLQueryItem] {
        let queriesDictionary = queries.dictionaryForQueries
    
        return queriesDictionary.enumerated().map {
            return URLQueryItem(name: "\($1.key)", value: "\($1.value)")
        }
    }

}
