//
//  ChangePasswordBody.swift
//  Networking
//
//  Created by Orest Patlyka on 2/11/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

struct ChangePasswordBody: Encodable {
    let newPassword: String
    let newPasswordConfirmation: String
    let currentPassword: String
}
