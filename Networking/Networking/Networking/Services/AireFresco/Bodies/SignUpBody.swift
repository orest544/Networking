//
//  SignUpBody.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 1/22/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

struct SignUpBody: Encodable {
    let email: String
    let firstName: String
    let lastName: String
    let password: String
}
