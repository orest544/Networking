//
//  AFWithQueriesService.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 1/29/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation
import BrightFutures

class AFWithQueriesService: RequestPerformable {
    
    func getPaymentPlans(queries: Encodable) -> Future<PaymentPlansModel, NetworkingError> {
        
        let endpoint = AFWithQueriesEndpoint.getPaymentPlans(queries: queries)
        let request = MyRequest(endpoint: endpoint)
        
        return performDataTask(with: request, logsEnable: true)
    }

}
