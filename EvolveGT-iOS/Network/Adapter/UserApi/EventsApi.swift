//
//  EventsApi.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 12/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class EventsApi : BaseApiAdapter{
    
    func fetchEvolveEventList(){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(ShopsApiConstants.EVOVLE_EVENTS)"
        setUrl(url: url)
        super.makeRequest(method: .POST)
    }
    
    func fetchMotoEventList(){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(ShopsApiConstants.MOTO_EVENTS)"
        setUrl(url: url)
        super.makeRequest(method: .POST)
    }
    
    func fetchEvolveEventDetails(){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(ShopsApiConstants.EVOVLE_EVENT_DETAILS)"
        setUrl(url: url)
        super.makeRequest(method: .POST)
    }
}
