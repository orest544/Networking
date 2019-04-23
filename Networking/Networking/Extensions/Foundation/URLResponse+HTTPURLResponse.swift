//
//  URLResponse+HTTPURLResponse.swift
//  Networking
//
//  Created by Orest Patlyka on 4/22/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

extension URLResponse {
    var httpURLResponse: HTTPURLResponse? {
        return self as? HTTPURLResponse
    }
}
