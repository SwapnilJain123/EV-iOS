//
//  GenericApi.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 15/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class GenericApi:BaseApiAdapter {
    
    func checkForAppUpdate(){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(AppApiConstants.APP_VERSION_CHECK)"
        setUrl(url: url)
        super.makeRequest(method: .GET)
    }
    
    func fetchSupportedCountries(){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(AppApiConstants.SUPPORTED_COUNTRIES)"
        setUrl(url: url)
        super.makeRequest(method: .GET)
    }
    func fetchSupportedStates(countryCode: String){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(AppApiConstants.SUPPORTED_STATES)"
        let request = SupportedStateRequest(countryCode: countryCode)
        setParameters(parameters: makeDictionary(request))
        setUrl(url: url)
        super.makeRequest(method: .POST)
    }
}
