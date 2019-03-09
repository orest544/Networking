//
//  SignInBody.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 1/25/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

struct SignInBody: Encodable {
    let email: String
    let password: String
}

