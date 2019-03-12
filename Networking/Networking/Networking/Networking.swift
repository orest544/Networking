//
//  Networking.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 1/10/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation
import BrightFutures

typealias DataTaskCompletionHandler = (Data?, URLResponse?, Error?) -> Void

fileprivate struct EmptyType: Encodable { }
struct EmptyResult: Decodable { }

// TEST
struct URLSessionDetails {
    let request: RequestCreatable
    let handler: DataTaskCompletionHandler
}

enum DataTaskDetailsStorage {
    static var detailsDict = [URLSessionDataTask: URLSessionDetails]()
}

protocol RequestPerformable {
    var session: URLSession { get }
    var decoder: JSONDecoder { get }
}

// NOTE: -  MAYBE ADD ASSOTIATED VALUE TO A PROTOCOL
extension RequestPerformable {
    
    // MARK: - Stuff
    var session: URLSession {
        let configuration = URLSessionConfiguration.default
        if #available(iOS 11.0, *) {
            // wait for conection restoring
            configuration.waitsForConnectivity = NetworkingSettings.waitsForConnectivity
            configuration.timeoutIntervalForResource = NetworkingSettings.timeoutIntervalForResource
        }
        return URLSession(configuration: configuration) //URLSession.shared
    }
    
    var decoder: JSONDecoder {
        return JSONDecoder.snakeCaseDecoder()
    }
    
    // MARK: - DataTask
    func performDataTask<ParsedType: Decodable>(with request: RequestCreatable,
                                                logsEnable: Bool = false) -> Future<ParsedType, NetworkingError> {
      
        let promise = Promise<ParsedType, NetworkingError>()
        
        let completionHandler: DataTaskCompletionHandler = { (data, response, error) in
            /// Handle Error
            if let networkingError = self.handleError(error) {
                // TEST
                switch networkingError {
                case .canceled: break
                default:
                    self.removeRequestFromStorage(request: request)
                    // TODO: Think about returnin value when .cancel
                    return promise.failure(networkingError)
                }
            }
            
            /// Check data and response
            guard let data = data,
                let response = response as? HTTPURLResponse else {
                    // TODO: Handle error
                    print("Smth goes wrong")
                    // TEST
                    self.removeRequestFromStorage(request: request)
                    return promise.failure(NetworkingError.badData)
            }
            
            /// LOGs
            if logsEnable {
                self.printLogs(with: request,
                               response: response,
                               parsedType: ParsedType.self,
                               data: data)
            }
            
            /// Validate status code
            switch response.validateStatusCode() {
            case .good: break
            case .refresh:
                print("make refresh")
                self.refreshToken()
                return
            case .bad:
                // TEST
                self.removeRequestFromStorage(request: request)
                return self.handeBadResponse(with: data, andGivePromiseFor: promise)
            }
            
            /// Check if needed only success or failure (if response have an empty JSON, and we need only checking status code)
            guard "\(ParsedType.self)" != "EmptyResult" else {
                let emptyResult = self.getEmptyResult(parsedType: ParsedType.self)
                // TEST
                self.removeRequestFromStorage(request: request)
                return promise.success(emptyResult)
            }
            
            /// Parse and return result
            do {
                let parsedData = try self.decoder.decode(ParsedType.self, from: data)
                // TEST
                self.removeRequestFromStorage(request: request)
                promise.success(parsedData)
            } catch let catchError {
                // TODO: Handle error
                print(catchError)
                // TEST
                self.removeRequestFromStorage(request: request)
                return promise.failure(NetworkingError.defaultError)
            }
        }
        
        let dataTask = session.dataTask(with: request.asURLRequest(), completionHandler: completionHandler)
        dataTask.resume()
        
        DataTaskDetailsStorage.detailsDict[dataTask] = URLSessionDetails(request: request,
                                                                         handler: completionHandler)
        
        return promise.future
    }
    
    // MARK: - Error handling
    private func handleError(_ error: Error?) -> NetworkingError? {
        guard let error = error else { return nil }
        // TODO: Handle error
        // -1001 timeout
        // -1009 inet connection
        print("\nNetworking ERROR: ", error, "\n")
        
        if error.code == -999 {
            return NetworkingError.canceled
        }
        
        return NetworkingError.defaultError
    }
    
    private func checkErrorInResponse(data: Data) -> NetworkingError? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            if let error = json?["error"] as? String {
                return NetworkingError.responseError(error)
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
        return nil
    }
    
    private func handeBadResponse<ParsedType: Decodable>(with data: Data,
                                                         andGivePromiseFor promise: Promise<ParsedType, NetworkingError>) {
        // TODO: Handle error
        if let responseError = self.checkErrorInResponse(data: data) {
            return promise.failure(responseError)
        }
        
        print("Smth goes wrong")
        return promise.failure(NetworkingError.defaultError)
    }
    
    // TODO: Move to extension or separate file
    // MARK: - LOGs
    private func printLogs<ParsedType: Decodable>(with request: RequestCreatable,
                                                  response: HTTPURLResponse,
                                                  parsedType: ParsedType.Type,
                                                  data: Data) {
        if let json = getJSONFrom(data: request.asURLRequest().httpBody ?? Data()) {
            print("\nBODY JSON: ", json)
        }
        
        print("\nFinal URL: \(request.endpoint.asURL())")
        print("Response code: \(response.statusCode) (\(ParsedType.self))" )
        
        if let json = getJSONFrom(data: data) {
            print("RESPONSE JSON: ", json)
        }
    }
    
    private func getJSONFrom(data: Data) -> Any? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            return json
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    // MARK: - Empty result
    private func getEmptyResult<ParsedType: Decodable>(parsedType: ParsedType.Type) -> ParsedType {
        
        let emptyEncodedObj = EmptyType()
        let data = try! emptyEncodedObj.myData()
        
        return try! self.decoder.decode(ParsedType.self, from: data)
    }
    
    // MARK: - Handle DataTaskDetailsStorage
    private func removeRequestFromStorage(request: RequestCreatable) {
        let urlSessionDataTasks = DataTaskDetailsStorage.detailsDict.compactMap({ (key, value) -> URLSessionDataTask? in
            if value.request === request {
                return key
            }
            return nil
        })
        
        urlSessionDataTasks.forEach({ (urlSessionDataTask) in
            DataTaskDetailsStorage.detailsDict.removeValue(forKey: urlSessionDataTask)
        })
    }
    
}

// TODO: Need to make refresh universal also for upload and download tasks
// MARK: - Refresh token
extension RequestPerformable {
    private func refreshToken() {
        
        DataTaskDetailsStorage.detailsDict.keys.forEach { $0.cancel() }
        
        let refreshTokenEndpoint = RefreshTokenEndpoint.refreshToken
        let refreshTokenRequest = MyRequest(endpoint: refreshTokenEndpoint)
        
        session.dataTask(with: refreshTokenRequest.asURLRequest()) { (data, response, error) in
            guard error == nil else {
                print("Refreshing token error: \(error?.localizedDescription)")
                RefreshTokenHandler.handleFailure()
                return
            }
            
            guard let response = response as? HTTPURLResponse, data != nil else {
                print("Refreshing token invalid response or data")
                RefreshTokenHandler.handleFailure()
                return
            }
            
            guard response.isStatusCodeInOkRange else {
                print("Refreshing token bad statusCode: \(response.statusCode)")
                RefreshTokenHandler.handleFailure()
                return
            }
            
            if let newToken = response.allHeaderFields[RefreshTokenSettings.fieldName] as? String {
                guard RefreshTokenHandler.handleSuccess(with: newToken) else {
                    print("cant save token to keychain and returning from refresh token")
                    RefreshTokenHandler.handleFailure()
                    return
                }
                
                print("calling api againg after refreshing")
                
                let urlSessionDetails = DataTaskDetailsStorage.detailsDict.values
                urlSessionDetails.forEach {
                    self.session.dataTask(with: $0.request.asURLRequest(),
                                          completionHandler: $0.handler).resume()
                }
            }
        }.resume()
    
    }
    
}


