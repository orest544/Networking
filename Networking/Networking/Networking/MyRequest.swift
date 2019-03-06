//
//  MyRequest.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 1/14/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

typealias Endpoint = RequestContructable & URLConstructable

class MyRequest: RequestCreatable {
    
    var endpoint: Endpoint
    var body: Encodable?
    
    init(endpoint: Endpoint, body: Encodable? = nil) {
        self.endpoint = endpoint
        self.body = body
    }
}
