//
//  TraxUserModel.swift
//  Networking
//
//  Created by Orest Patlyka on 3/9/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

struct TraxUserModel: Decodable {
    let data: UserData
}

struct UserData: Decodable {
    let tokenType: String
    let accessToken: String
}
