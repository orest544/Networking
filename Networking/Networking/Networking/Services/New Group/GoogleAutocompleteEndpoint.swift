//
//  GoogleAutocompleteEndpoint.swift
//  Networking
//
//  Created by Orest Patlyka on 2/26/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

struct GoogleAutocompleteEndpoint: Endpoint {
    var server: Server 
    
    var path: String
    
    var queries: Encodable?
    
    var method: HTTPMethod
    
    var isAuthTokenRequired: Bool
}
