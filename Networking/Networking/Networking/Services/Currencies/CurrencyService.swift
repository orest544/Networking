//
//  CurrencyService.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 1/10/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation
import BrightFutures

class CurrencyService: RequestPerformable {
    
    func getCurrencies() -> Future<Currencies, NetworkingError> {

        let request = MyRequest(endpoint: CurrencyEndpoint.getCurrencies)
        return performDataTask(with: request, logsEnable: true)
    }

}
