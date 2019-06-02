//
//  NervyVideoService.swift
//  Networking
//
//  Created by Orest Patlyka on 5/31/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

struct NervyVideoBody: Encodable {
    let video: Data
}

struct NervyVideoService: RequestPerformable {
    func uploadNervyVideo(_ videoBody: NervyVideoBody) -> UploadTaskFuture {
        let endpoint = NervyVideoEndpoint.uploadVideo
        let request = MyRequest(endpoint: endpoint, body: videoBody)
        
        return performDataTask(with: request, logsEnable: true)
    }
}
