//
//  DownloadTask.swift
//  Networking
//
//  Created by Orest Patlyka on 3/14/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

extension RequestPerformable {
    
    func performDownloadTask(with request: RequestCreatable) {
        session.downloadTask(with: request.asURLRequest()) { (fileURL, response, error) in
        
            print("Error: ", error as Any)
            print("FileURL: ", fileURL as Any)
            print("Response: ", response as Any)
            
        }.resume()
    }
    
}


