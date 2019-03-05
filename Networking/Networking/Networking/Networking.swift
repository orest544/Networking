//
//  Networking.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 1/10/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation
import BrightFutures

//protocol Typed {
//    associatedtype T
//    var promise: Promise<T, NetworkingError> { set get }
//}

//struct MyPromise<T: Decodable>: Typed {
//    var promise: Promise<T, NetworkingError>
//}

//struct RequestDetails {
//    let request: RequestCreatable
//    var promise: AnyObject
//    let type: Any.Type
//}
//
//struct RequestDetailsStorage {
//    static var dict = [URLSessionDataTask: RequestDetails]()
//}

//struct PromiseStorage<ParsedType: Decodable> {
//    var currentPromise: Promise<ParsedType, NetworkingError>?
//}


fileprivate struct EmptyType: Encodable {
    
}

struct EmptyResult: Decodable {
    
}

// TEST
struct CompletionHandlerStorage {
    static var handlers = [(Data?, URLResponse?, Error?) -> Void]()
}

// NOTE: This is for having access to dataTask inside in completion handler
struct CurrentDataTaskStorage {
    static var dataTask: URLSessionDataTask?
}


enum DataTasksStorage {
    static var tasks = [URLSessionDataTask]()
    static var tempTasks = [URLSessionDataTask]()
}


protocol RequestPerformable {
    var session: URLSession { get }
    var decoder: JSONDecoder { get }
}

// NOTE: -  MAYBE ADD ASSOTIATED VALUE TO A PROTOCOL
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
        
        let completionHandler: (Data?, URLResponse?, Error?) -> Void = { (data, response, error) in
            /// Handle Error
            if let networkingError = self.handleError(error) {
                // TEST
                if let dataTask = CurrentDataTaskStorage.dataTask {
                    DataTasksStorage.tasks = DataTasksStorage.tasks.filter { $0 !== dataTask }
                    DataTasksStorage.tempTasks = DataTasksStorage.tempTasks.filter { $0 !== dataTask }
                }
                return promise.failure(networkingError)
            }
            
            /// Check data and response
            guard let data = data,
                let response = response as? HTTPURLResponse else {
                    // TODO: Handle error
                    print("Smth goes wrong")
                    // TEST
                    if let dataTask = CurrentDataTaskStorage.dataTask {
                        DataTasksStorage.tasks = DataTasksStorage.tasks.filter { $0 !== dataTask }
                        DataTasksStorage.tempTasks = DataTasksStorage.tempTasks.filter { $0 !== dataTask }
                    }
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
                return self.handeBadResponse(with: data, andGivePromiseFor: promise)
            }
            
            /// Check if needed only true or false (if response have an empty JSON, and we need only checking status code)
            guard "\(ParsedType.self)" != "EmptyResult" else {
                let emptyResult = self.getEmptyResult(parsedType: ParsedType.self)
                // TEST
                if let dataTask = CurrentDataTaskStorage.dataTask {
                    DataTasksStorage.tasks = DataTasksStorage.tasks.filter { $0 !== dataTask }
                    DataTasksStorage.tempTasks = DataTasksStorage.tempTasks.filter { $0 !== dataTask }
                }
                return promise.success(emptyResult)
            }
            
            /// Parse and return result
            do {
                let parsedData = try self.decoder.decode(ParsedType.self, from: data)
                // TEST
                if let dataTask = CurrentDataTaskStorage.dataTask {
                    DataTasksStorage.tasks = DataTasksStorage.tasks.filter { $0 !== dataTask }
                    DataTasksStorage.tempTasks = DataTasksStorage.tempTasks.filter { $0 !== dataTask }
                }
                promise.success(parsedData)
            } catch let catchError {
                // TODO: Handle error
                print(catchError)
                // TEST
                if let dataTask = CurrentDataTaskStorage.dataTask {
                    DataTasksStorage.tasks = DataTasksStorage.tasks.filter { $0 !== dataTask }
                    DataTasksStorage.tempTasks = DataTasksStorage.tempTasks.filter { $0 !== dataTask }
                }
                return promise.failure(NetworkingError.defaultError)
            }
        }
        
        CompletionHandlerStorage.handlers.append(completionHandler)
        
        let dataTask = session.dataTask(with: request.asURLRequest(), completionHandler: completionHandler)
        
        DataTasksStorage.tasks.append(dataTask)
        #warning("MB NEED COPY NOT REFERENCE!")
        // unreal make copy of dataTask(
        DataTasksStorage.tempTasks.append(dataTask.copy() as! URLSessionDataTask)
        
        CurrentDataTaskStorage.dataTask = dataTask
        //CurrentDataTaskStorage.dataTask?.resume()
        
        return promise.future
    }
    
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
            // TODO: Remove force unwrap
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
    
    private func handeBadResponse<ParsedType: Decodable>(with data: Data,
                                                         andGivePromiseFor promise: Promise<ParsedType, NetworkingError>) {
        // TEST
        if let dataTask = CurrentDataTaskStorage.dataTask {
            DataTasksStorage.tasks = DataTasksStorage.tasks.filter { $0 !== dataTask }
            DataTasksStorage.tempTasks = DataTasksStorage.tempTasks.filter { $0 !== dataTask }
        }
        
        // TODO: Handle error
        if let responseError = self.checkErrorInResponse(data: data) {
            return promise.failure(responseError)
        }
        
        print("Smth goes wrong")
        return promise.failure(NetworkingError.defaultError)
    }
    
    // MARK: - LOGs
    private func printLogs<ParsedType: Decodable>(with request: RequestCreatable,
                                                  response: HTTPURLResponse,
                                                  parsedType: ParsedType.Type,
                                                  data: Data) {
        print("\nFinal URL: \(request.endpoint.asURL())")
        print("Response code: \(response.statusCode) (\(ParsedType.self))" )
        
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

// TODO: Need to make refresh universal also for upload and download tasks
// MARK: - Refresh token
extension RequestPerformable {
    private func refreshToken() {
        
        DataTasksStorage.tasks.forEach { $0.cancel() }
        DataTasksStorage.tasks.removeAll()
        
        let refreshTokenEndpoint = RefreshTokenEndpoint.refreshToken
        let refreshTokenRequest = MyRequest(endpoint: refreshTokenEndpoint)
        
        session.dataTask(with: refreshTokenRequest.asURLRequest()) { (data, response, error) in
            guard error == nil else {
                print("Refreshing token error \(error?.localizedDescription)")
                RefreshTokenHandler.handleFailure()
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Refreshing token bad response")
                RefreshTokenHandler.handleFailure()
                return
            }
            
            // TODO: Think about this hardcode
            guard response.statusCode == 200 else {
                print("Refreshing token bad statusCode: \(response.statusCode)")
                RefreshTokenHandler.handleFailure()
                return
            }
            
            guard data != nil else {
                print("Refreshing token bad data, data: \(String(describing: data))")
                RefreshTokenHandler.handleFailure()
                return
            }
            
            // TODO: Remove hardcode
            if let newToken = response.allHeaderFields["Authorization"] as? String {
                guard RefreshTokenHandler.handleSuccess(with: newToken) else {
                    print("cant save token to keychain and returning from refresh token")
                    RefreshTokenHandler.handleFailure()
                    return
                }
                
                print("calling api againg after refreshing")
                #warning("Call all request again")
                
//                DataTasksStorage.tempTasks.forEach {
//                    $0.resume()
//                }
            
            }
        }.resume()
    }
}


