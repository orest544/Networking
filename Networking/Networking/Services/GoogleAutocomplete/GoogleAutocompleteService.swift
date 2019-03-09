//
//  GoogleAutocompleteService.swift
//  Networking
//
//  Created by Orest Patlyka on 2/27/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation
import BrightFutures

struct GoogleAutocompleteService: RequestPerformable {
    
    func getGoogleAutocomplete(with queries: GoogleAutocompleteQueries) -> Future<GoogleAutocompleteModel, NetworkingError> {
        
        let getAutocompleteEndpoint = GoogleAutocompleteEndpoint.getAutocomplete(queries: queries)
        let getAutocompleteRequest = CustomRequest(endpoint: getAutocompleteEndpoint)
        
        return performDataTask(with: getAutocompleteRequest,
                               logsEnable: true)
    }
    
}
