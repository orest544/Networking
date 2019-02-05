//
//  PaymentPlansModel.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 1/29/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

struct PaymentPlansModel: Decodable {
    var data: [SubscriptionPlanData] = []
}

struct SubscriptionPlanData: Codable {
    
    let id: Int
    let interval: String
    let intervalCount: Int
    let amount: Double
    let currency: String
    let currencySymbol: String
    let nickname: String
    let amountPerMonth: Double
    let diffInPercent: Double?
    let discountAmount: Double?
    let description: String
    let discountAmountPerMonth: Double?
    let active: Bool
    let isPostponed: Bool
    let amountOff: Int?
    let percentOff: Double?
    let mostPopular: Bool
    
//    enum CodingKeys: String, CodingKey {
//        case id, interval
//        case intervalCount = "interval_count"
//        case amount, currency, nickname
//        case currencySymbol = "currency_symbol"
//        case amountPerMonth = "amount_per_month"
//        case diffInPercent = "diff_in_percent"
//        case discountAmount = "discount_amount"
//        case description
//        case discountAmountPerMonth = "discount_amount_per_month"
//        case active
//        case isPostponed = "is_postponed"
//        case amountOff = "amount_off"
//        case percentOff = "percent_off"
//        case mostPopular = "most_popular"
//    }
}

