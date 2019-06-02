//
//  DownloadTask.swift
//  Networking
//
//  Created by Orest Patlyka on 3/14/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation
import BrightFutures

typealias DownloadTaskPromise = Promise<URL, NetworkingError>
typealias DownloadTaskFuture = Future<URL, NetworkingError>

typealias UploadTaskPromise = Promise<EmptyResult, NetworkingError>
typealias UploadTaskFuture = Future<EmptyResult, NetworkingError>

typealias ProgressHandler = (Float) -> Void


struct URLSessionUploadDetails {
    let request: RequestCreatable
    let handler: DataTaskCompletionHandler
}

enum UploadTaskDetailsStorage {
    static var detailsDict = [URLSessionDownloadTask: URLSessionUploadDetails]()
}

extension RequestPerformable {
    func performDownloadTask(with request: RequestCreatable,
                             saveTo fileURL: URL,
                             progress: ProgressHandler? = nil,
                             logsEnable: Bool = false) -> DownloadTaskFuture {
        
        return Download().performDownloadTask(with: request,
                                              saveTo: fileURL,
                                              progress: progress,
                                              logsEnable: logsEnable)
    }
}


class Download: NSObject, URLSessionDownloadDelegate, BaseDelegateRequest {
    
    // TODO: Solve the problem with URLSession delegate!
    
    private var promise = DownloadTaskPromise()
//    private var request: RequestCreatable!
    private var fileURL = FileManager.default.temporaryDirectory
    private var progressHandler: ProgressHandler?
    private var progress: Float = 0.0 {
        didSet {
            // call progress closure
            progressHandler?(progress)
        }
    }
    
    override init() {
        print("Downloading inited")
    }
    
    deinit {
        print("Downloading deinited")
    }
    
    func performDownloadTask(with request: RequestCreatable,
                             saveTo fileURL: URL,
                             progress: ProgressHandler? = nil,
                             logsEnable: Bool = false) -> DownloadTaskFuture {
        self.fileURL = fileURL
        progressHandler = progress
        
        var urlRequest = request.asURLRequest()
        urlRequest.timeoutInterval = NetworkingSettings.downloadUploadRequestTimeout
        let task = sessionWithDelegate.downloadTask(with: urlRequest)
        task.resume()
        
        return promise.future
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Location: ", location)
        
        /// Check response
        guard let response = downloadTask.response?.httpURLResponse else {
            // TODO: Handle error
            print("Smth goes wrong")
            // TEST
            #warning("Remove from storage")
//            self.removeRequestFromStorage(request: request)
            return promise.failure(.badData)
        }
        
        /// Validate status code
        switch response.validateStatusCode() {
        case .good: break
        case .refresh:
            optimizedPrint("making refresh token")
            #warning("refresh")
            //            self.refreshToken()
            return
        case .bad:
            // TEST
            #warning("remove")
//            self.removeRequestFromStorage(request: request)
//            return self.handeBadResponse(with: data, andGivePromiseFor: promise)
            promise.failure(.badData)
            break
        }

        try? FileManager.default.removeItem(at: fileURL)
        do {
            try FileManager.default.moveItem(at: location, to: fileURL)
            print("File moved to: \(fileURL)")
            promise.success(fileURL)
        } catch {
            // TODO: HANDLE
            print(error.localizedDescription)
        }
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
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
    
}

extension Download {
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
}


