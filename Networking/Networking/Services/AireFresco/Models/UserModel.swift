//
//  UserModel.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 1/22/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

struct UserModel: Decodable {
    let id: Int
    let email: String
    let firstName: String?
    let lastName: String?
    let avatarLogo: String?
    let nickname: String?
    let gender: Bool?
    let location: String?
    let count: Int?
    let client: Client?
    let meta: UserMeta
}

struct Client: Decodable {
    let id: Int?
    let via: String?
    let type: String?
    let expireAt: Int?
    let newsletter: Bool?
    let premiumNews: String?
    let isPremium: Bool?
    
    let gift: ClientGift?
    let subscription: ClientSubscription?
    let postponeSubscription: ClientPostponeSubscription?
}

struct UserMeta: Decodable {
    let token: String
}

struct ClientGift: Decodable {
    let expiredAt: Int
    let appliedAt: Int
}

struct ClientSubscription: Codable {
    let startDate: Int
    let endDate: Int
    let interval: String
    let intervalCount: Int
    let status: String
}

struct ClientPostponeSubscription: Codable {
    let startDate: Int
    let interval: String
    let intervalCount: String
    let nickname: String
}
