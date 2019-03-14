//
//  TestDownloadService.swift
//  Networking
//
//  Created by Orest Patlyka on 3/14/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

struct TestDownloadService: RequestPerformable {
    
    func downloadSession() {
        let downloadEndpoint = TestDownloadEndpoint.downloadSession
        let request = MyRequest(endpoint: downloadEndpoint)
        
        performDownloadTask(with: request)
    }
    
}
