//
//  TestDownloadService.swift
//  Networking
//
//  Created by Orest Patlyka on 3/14/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation
import BrightFutures

protocol TestDownloadServiceInterface {
    func downloadSession(downloadProgress: @escaping ProgressHandler) -> DownloadTaskFuture
    func uploadPhoto(body: UpdateAvatarBody, uploadingProgress: @escaping ProgressHandler) -> Future<EmptyResult, NetworkingError>
}

struct TestDownloadService: RequestPerformable, TestDownloadServiceInterface {
    func downloadSession(downloadProgress: @escaping ProgressHandler) -> DownloadTaskFuture {
        let downloadEndpoint = TestDownloadEndpoint.downloadSession
        let request = MyRequest(endpoint: downloadEndpoint)
        
        let documentsUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let destination = documentsUrl.appendingPathComponent("test").appendingPathExtension("mp3")
        
        return performDownloadTask(with: request,
                                   saveTo: destination,
                                   progress: downloadProgress)
    }
    
    func uploadPhoto(body: UpdateAvatarBody, uploadingProgress: @escaping ProgressHandler) -> Future<EmptyResult, NetworkingError> {
        let uploadEndpoint = TestDownloadEndpoint.uploadPhoto
        let request = MyRequest(endpoint: uploadEndpoint, body: body, bodyData: nil)
        
        return performDataTask(with: request, logsEnable: true)
    }
}

struct UpdateAvatarBody: Encodable {
    let avatar: Data
}
