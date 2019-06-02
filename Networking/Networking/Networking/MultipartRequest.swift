//
//  MultipartRequest.swift
//  Networking
//
//  Created by Orest Patlyka on 6/2/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

typealias Parameters = [String: String]

struct MultipartData {
    let parameters: Parameters?
    let media: [Media]?
}

class MultipartRequest {
    
    var endpoint: Endpoint
    var multipartData: MultipartData
    
    private let boundary = String.generateBoundary
    
    init(endpoint: Endpoint, multipartData: MultipartData) {
        self.endpoint = endpoint
        self.multipartData = multipartData
    }
    
    func addStandartHeadersFor(request: inout URLRequest) {
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
    }
    
    // TODO: mb move this to URLRequest extension
    func addAuthHeaderFor(request: inout URLRequest) {
        // NOTE: Retrieve token, customize for your porposes
        let userID = UserDefaults.standard.integer(forKey: "userID")
        let token = KeychainManager.readTokenFromKeychain(userID)
        
        request.setValue(token, forHTTPHeaderField: "Authorization")
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
        
        urlRequest.httpBody = createDataBody(withParameters: multipartData.parameters,
                                             media: multipartData.media,
                                             boundary: boundary)
        
        // Additional request settings
        urlRequest.timeoutInterval = NetworkingSettings.requestTimeout
        
        return urlRequest
    }

    func createDataBody(withParameters params: Parameters?, media: [Media]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        params?.forEach { key, value in
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
            body.append("\(value + lineBreak)")
        }
        
        //    if let parameters = params {
        //        for (key, value) in parameters {
        //            body.append("--\(boundary + lineBreak)")
        //            body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
        //            body.append("\(value + lineBreak)")
        //        }
        //    }
        
        media?.forEach { media in
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(media.key)\"; filename=\"\(media.filename)\"\(lineBreak)")
            body.append("Content-Type: \(media.mimeType.type + lineBreak + lineBreak)")
            body.append(media.data)
            body.append(lineBreak)
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    
}

extension String {
    static var generateBoundary: String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

