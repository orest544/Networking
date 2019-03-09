//
//  LoginCredentialsModel.swift
//  Networking
//
//  Created by Orest Patlyka on 3/9/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

struct LoginCredentialsModel: Encodable {
    let email: String
    let password: String
}
