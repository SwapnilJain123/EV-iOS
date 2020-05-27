//
//  ArchiCardAPI.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 27/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class ArchieCardApi:BaseApiAdapter{
    
    func fetchArchieCardList(){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(ShopsApiConstants.ARCHIE_CARD_LIST)"
        setUrl(url: url)
        super.makeRequest(method: .GET)
    }
    
}
