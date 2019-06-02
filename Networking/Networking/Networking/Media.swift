//
//  Media.swift
//  URLSessionMPFD
//
//  Created by Kyle Lee on 4/29/17.
//  Copyright © 2017 Kyle Lee. All rights reserved.
//

import UIKit

enum MimeType {
    case video
    case image
    case custom(String)
    
    var type: String {
        switch self {
        case .image:
            return "image/jpeg"
        case .video:
            return "video/mp4"
        case .custom(let type):
            return type
        }
    }
}

struct Media {
    let key: String
    let data: Data
    let mimeType: MimeType
    let filename: String
}
