//
//  ProfileModel.swift
//  Networking
//
//  Created by Orest Patlyka on 3/9/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

struct ProfileModel: Decodable {
    let data: ProfileData
}

struct ProfileData: Decodable {
    let email: String
    let lastName: String
    let firstName: String
    let phoneNumber: String?
    let nickname: String
}

