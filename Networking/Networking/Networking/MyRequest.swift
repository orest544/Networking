//
//  MyRequest.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 1/14/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

typealias Endpoint = RequestContructable & URLConstructable

// Need class type for compare references
class MyRequest: RequestCreatable {
    
    var endpoint: Endpoint
    var body: Encodable?
    // test
    var bodyData: Data?
    
    init(endpoint: Endpoint, body: Encodable? = nil, bodyData: Data? = nil) {
        self.endpoint = endpoint
        self.body = body
        self.bodyData = bodyData
    }
}
