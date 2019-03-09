//
//  GoogleAutocompleteQueries.swift
//  Networking
//
//  Created by Orest Patlyka on 2/27/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

struct GoogleAutocompleteQueries: Encodable {
    let input: String
    let key: String = "AIzaSyAwd6NP219b6YdvLv3iJxzAkzlPoFiJfws"
    let components: String? = "country:AE|country:EG"
}
