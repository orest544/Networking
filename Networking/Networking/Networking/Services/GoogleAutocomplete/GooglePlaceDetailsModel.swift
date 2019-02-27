//
//  GooglePlaceDetailsModel.swift
//  Networking
//
//  Created by Orest Patlyka on 2/26/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

struct PlaceDetailsModel: Decodable {
    let result: PlaceDetailsResult
}

struct PlaceDetailsResult: Decodable {
    let geometry: Geometry
}

struct Geometry: Decodable {
    let location: Location
}

struct Location: Decodable {
    let lat: Double
    let lng: Double
}
