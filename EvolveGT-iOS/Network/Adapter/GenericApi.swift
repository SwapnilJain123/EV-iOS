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
    
}
