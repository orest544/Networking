//
//  UploadTask.swift
//  Networking
//
//  Created by Orest Patlyka on 6/2/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation
import BrightFutures

class Upload<ParsedType: Decodable>: NSObject, BaseDelegateRequest, URLSessionDataDelegate {
    
    // TODO: Solve the problem with URLSession delegate!
    
    private var promise: Promise<ParsedType, NetworkingError>
    //    private var request: RequestCreatable!
    //    private var fileURL = FileManager.default.temporaryDirectory
    private var logsEnable = false
    private var progressHandler: ProgressHandler?
    private var progress: Float = 0.0 {
        didSet {
            // call progress closure
            progressHandler?(progress)
        }
    }
    
    var decoder: JSONDecoder {
        return JSONDecoder.snakeCaseDecoder()
    }
    
    init(parsedType: ParsedType.Type) {
        promise = Promise<ParsedType, NetworkingError>()
        print("upload inited")
    }
    
    deinit {
        print("upload deinited")
    }
    
    func performUploadTask(with request: URLRequest,
                           progress: ProgressHandler? = nil,
                           logsEnable: Bool = false) -> Future<ParsedType, NetworkingError> {
        //        promise = Promise<ParsedType, NetworkingError>()
        progressHandler = progress
        self.logsEnable = logsEnable
        
        var urlRequest = request//request.asURLRequest()
        RequestCreatable
        urlRequest.timeoutInterval = NetworkingSettings.downloadUploadRequestTimeout
        
        let task = sessionWithDelegate.dataTask(with: urlRequest)
        task.resume()
        
        return promise.future
    }
    
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didSendBodyData bytesSent: Int64,
                    totalBytesSent: Int64,
                    totalBytesExpectedToSend: Int64) {
        print("totalBytesExpectedToSend: \(Double(totalBytesExpectedToSend) / 1_000_000.0) Mb")
        print("totalBytesSent: \(Double(totalBytesSent) / 1_000_000.0) Mb")
        progress = Float(totalBytesSent)/Float(totalBytesExpectedToSend)
    }
    
    
    // MARK: - ERROR
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("Error: ", error as Any)
        
        /// Handle Error
        if let networkingError = handleError(error) {
            // TEST
            switch networkingError {
            case .canceled: break
            default:
                #warning("Remove from storage")
                //                self.removeRequestFromStorage(request: request)
                // TODO: Think about returnin value when .cancel
                return promise.failure(networkingError)
            }
        }
        
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print("data recieved: ", data)
        // parse
        
        print(dataTask.response?.httpURLResponse?.statusCode as Any)
        guard let response = dataTask.response?.httpURLResponse else {
            // TODO: Handle error
            print("Smth goes wrong")
            // TEST
            //            self.removeRequestFromStorage(request: request)
            return promise.failure(NetworkingError.badData)
        }
        
        /// LOGs
        if logsEnable {
            self.printLogs(with: dataTask.currentRequest,
                           response: response,
                           parsedType: ParsedType.self,
                           data: data)
        }
        
        /// Validate status code
        switch response.validateStatusCode() {
        case .good: break
        case .refresh:
            optimizedPrint("making refresh token")
            // TODO: Refresh token
            //            self.refreshToken()
            return
        case .bad:
            // TEST
            //            self.removeRequestFromStorage(request: request)
            return self.handeBadResponse(with: data, andGivePromiseFor: promise)
        }
        
        /// Check if needed only success or failure (if response have an empty JSON, and we need only checking status code)
        guard "\(ParsedType.self)" != "EmptyResult" else {
            let emptyResult = self.getEmptyResult(parsedType: ParsedType.self)
            // TEST
            //            self.removeRequestFromStorage(request: request)
            return promise.success(emptyResult)
        }
        
        /// Parse and return result
        do {
            let parsedData = try self.decoder.decode(ParsedType.self, from: data)
            // TEST
            //            self.removeRequestFromStorage(request: request)
            promise.success(parsedData)
        } catch let catchError {
            // TODO: Handle error
            print(catchError)
            // TEST
            //            self.removeRequestFromStorage(request: request)
            return promise.failure(NetworkingError.cantParseData)
        }
        
    }
}


extension Upload {
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
    
    // MARK: - Empty result
    private func getEmptyResult<ParsedType: Decodable>(parsedType: ParsedType.Type) -> ParsedType {
        
        let emptyEncodedObj = EmptyType()
        let data = try! emptyEncodedObj.myData()
        
        return try! self.decoder.decode(ParsedType.self, from: data)
    }
    
    // MARK: - LOGs
    private func printLogs<ParsedType: Decodable>(with request: URLRequest?,
                                                  response: HTTPURLResponse,
                                                  parsedType: ParsedType.Type,
                                                  data: Data) {
        optimizedPrint("\nFinal URL: \(request?.url ?? URL(fileURLWithPath: ""))")
        optimizedPrint("Response code: \(response.statusCode) (\(ParsedType.self))" )
        
        //        if let json = getJSONFrom(data: request.httpBody ?? Data()) {
        //            optimizedPrint("\nBODY JSON: \(json)")
        //        }
        
        if let json = getJSONFrom(data: data) {
            optimizedPrint("RESPONSE JSON: \(json)")
        }
    }
    
    private func getJSONFrom(data: Data) -> Any? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            return json
        } catch {
            return nil
        }
    }
    
}




