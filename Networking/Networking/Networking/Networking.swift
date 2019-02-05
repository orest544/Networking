//
//  Networking.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 1/10/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation
import BrightFutures

protocol RequestPerformable {
    var session: URLSession { get }
    var decoder: JSONDecoder { get }
    
    func performDataTask<ParsedType: Codable>(with request: RequestCreatable,
                                              logsEnable: Bool) -> Future<ParsedType, NetworkingError>
}

extension RequestPerformable {
    
    // MARK: - Stuff
    var session: URLSession {
        return URLSession.shared
    }
    
    var decoder: JSONDecoder {
        return JSONDecoder.snakeCaseDecoder()
    }
    
    // MARK: - DataTask
    func performDataTask<ParsedType: Decodable>(with request: RequestCreatable,
                                                logsEnable: Bool = true) -> Future<ParsedType, NetworkingError> {
        
        let promise = Promise<ParsedType, NetworkingError>()
        
        let dataTask = session.dataTask(with: request.asURLRequest()) { (data, response, error) in
            if let error = error {
                // TODO: Handle error
                // -1001 timeout
                // -1009 inet connection
                print("\nNetworking ERROR: ", error, "\n")
                return promise.failure(NetworkingError.defaultError)
            }
            
            guard let data = data,
                let response = response as? HTTPURLResponse else {
                    // TODO: Handle error
                    print("Smth goes wrong")
                    return promise.failure(NetworkingError.defaultError)
            }
            
            ///----------------------------------------
            // LOGs
            if logsEnable {
                self.printLogs(with: response,
                               parsedType: ParsedType.self,
                               data: data)
            }
            ///----------------------------------------
            
            guard response.isStatusCodeInOkRange else {
                    // TODO: Handle error
                    print("Smth goes wrong")
                    return promise.failure(NetworkingError.defaultError)
            }
            
            do {
                let parsedData = try self.decoder.decode(ParsedType.self, from: data)
                promise.success(parsedData)
            } catch let catchError {
                // TODO: Handle error
                print(catchError)
                return promise.failure(NetworkingError.defaultError)
            }
        }
        dataTask.resume()
        
        return promise.future
    }
    
    // MARK: - LOGs
    private func printLogs<ParsedType: Decodable>(with response: HTTPURLResponse,
                                                  parsedType: ParsedType.Type,
                                                  data: Data) {
        print("\nResponse code: \(response.statusCode) (\(ParsedType.self))" )
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            print("RESPONSE JSON: ", json)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
