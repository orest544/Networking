//
//  NervyVideoService.swift
//  Networking
//
//  Created by Orest Patlyka on 5/31/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

struct NervyVideoService {
    func uploadNervyVideo(videoURL: URL, progress: ProgressHandler? = nil) -> UploadTaskFuture {
        
        let videoData = try! Data(contentsOf: videoURL)
        let video = Media(key: "video",
                          data: videoData,
                          mimeType: .video,
                          filename: "NervyVideo")
        let multipartData = MultipartData(parameters: nil,
                                          media: [video])
        
        let request = MultipartRequest(endpoint: NervyVideoEndpoint.uploadVideo,
                                       multipartData: multipartData)
        
        let uploader = Upload(parsedType: EmptyResult.self)
        
        return uploader.performUploadTask(with: request,
                                          progress: progress,
                                          logsEnable: true)
    }
}
