//
//  RequestCreatable.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 1/10/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

protocol RequestCreatable {
    var endpoint: Endpoint { get set }
    var body: Encodable? { get set }
    
    func addStandartHeadersFor(request: inout URLRequest)
    func addParametersFor(request: inout URLRequest, parameters: Encodable) throws
    
    func asURLRequest() -> URLRequest
}

extension RequestCreatable {
    
    func addStandartHeadersFor(request: inout URLRequest) {
        request.addValue("application/json", forHTTPHeaderField: "content-type")
    }
    
    func addAuthHeaderFor(request: inout URLRequest) {
        
        // NOTE: Retrieve token, customize for your porposes
        let userID = UserDefaults.standard.string(forKey: "userID")
        let token = KeychainManager.readTokenFromKeychain(idString: userID)
        
        request.setValue(token, forHTTPHeaderField: "Authorization")
    }
    
    func addParametersFor(request: inout URLRequest, parameters: Encodable) throws {
        do {
            let data = try parameters.myData()
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            print("BODY JSON: ", json)
            request.httpBody = data//try parameters.myData()
        } catch {
            // TODO: MAKE SPECIAL ERROR
            throw NetworkingError.defaultError
        }
    }
    
    func asURLRequest() -> URLRequest {
        
        // Make a request and adding headers with token etc.
        let destinationUrl = endpoint.asURL()
        var urlRequest = URLRequest(url: destinationUrl)
        
        urlRequest.httpMethod = endpoint.method.rawValue
        addStandartHeadersFor(request: &urlRequest)
        
        if endpoint.isAuthTokenRequired {
            addAuthHeaderFor(request: &urlRequest)
        }
        
        if let body = body {
            do {
                try addParametersFor(request: &urlRequest, parameters: body)
            } catch {
                // TODO: MAKE SPECIAL ERROR
                print("Error in asURLRequest: ", error.localizedDescription)
                assert(false, "Can't add parameters for request")
            }
        }
        
        // Additional request settings
        urlRequest.timeoutInterval = 10
        
        return urlRequest
    }

}


