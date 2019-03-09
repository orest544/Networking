//
//  Networking.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 1/10/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation
import BrightFutures

struct EmptyType: Encodable { }
struct EmptyResult: Decodable { }

protocol RequestPerformable {
    var session: URLSession { get }
    var decoder: JSONDecoder { get }
    
    func performDataTask<ParsedType: Codable>(with request: RequestCreatable,
                                              logsEnable: Bool) -> Future<ParsedType, NetworkingError>
}

// TODO: - MAYBE ADD ASSOTIATED VALUE TO A PROTOCOL
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
                                                logsEnable: Bool = false) -> Future<ParsedType, NetworkingError> {
        
        let promise = Promise<ParsedType, NetworkingError>()
        
        let dataTask = session.dataTask(with: request.asURLRequest()) { (data, response, error) in
            
            /// Handle Error
            if let networkingError = self.handleError(error) {
                return promise.failure(networkingError)
            }
            
            /// Check data and response
            guard let data = data,
                let response = response as? HTTPURLResponse else {
                    // TODO: Handle error
                    print("Smth goes wrong")
                    return promise.failure(NetworkingError.badData)
            }
            
            /// LOGs
            if logsEnable {
                self.printLogs(with: request,
                               response: response,
                               parsedType: ParsedType.self,
                               data: data)
            }
            
            ///
            guard response.isStatusCodeInOkRange else {
                    // TODO: Handle error
                if let responseError = self.checkErrorInResponse(data: data) {
                    return promise.failure(responseError)
                }
                
                print("Smth goes wrong")
                return promise.failure(NetworkingError.defaultError)
            }
            
            /// Check if needed only true or false (if response have an empty JSON, and we need only checking status code)
            guard "\(ParsedType.self)" != "EmptyResult" else {
                
                let emptyResult = self.getEmptyResult(parsedType: ParsedType.self)
                return promise.success(emptyResult)
            }
            
            ///
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
}

// MARK: - Helpfull methods
extension RequestPerformable {

    // MARK: - Error handling
    private func handleError(_ error: Error?) -> NetworkingError? {
        guard let error = error else { return nil }
        // TODO: Handle error
        // -1001 timeout
        // -1009 inet connection
        print("\nNetworking ERROR: ", error, "\n")
        return NetworkingError.defaultError
    }
    
    private func checkErrorInResponse(data: Data) -> NetworkingError? {
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            if let error = json["error"] as? String {
                return NetworkingError.responseError(error)
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
        return nil
    }
    
    // MARK: - LOGs
    private func printLogs<ParsedType: Decodable>(with request: RequestCreatable,
                                                  response: HTTPURLResponse,
                                                  parsedType: ParsedType.Type,
                                                  data: Data) {
        print("\nFinal URL: \(request.endpoint.asURL())")
        print("\nResponse code: \(response.statusCode) (\(ParsedType.self))" )
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            print("RESPONSE JSON: ", json)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Empty result
    private func getEmptyResult<ParsedType: Decodable>(parsedType: ParsedType.Type) -> ParsedType {
        
        let emptyEncodedObj = EmptyType()
        let data = try! emptyEncodedObj.myData()
        
        return try! self.decoder.decode(ParsedType.self, from: data)
    }
    
}
    

