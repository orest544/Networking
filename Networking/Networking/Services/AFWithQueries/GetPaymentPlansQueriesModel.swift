//
//  GetPaymentPlansQueriesModel.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 2/4/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

struct GetPaymentPlansQuery: Encodable {
    let countryCode: String
    let coupon: String?
}
