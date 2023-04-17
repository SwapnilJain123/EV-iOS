//
//  WaiverApi.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 04/09/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class WaiverApi:BaseApiAdapter{
    
    func fetchWaiverList(){
           
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.WAIVER_LIST)"
           setUrl(url: url)
           super.makeRequest(method: .GET)
       }
    
    func fetchWaiverDetails(waiverDetailsRequest:WaiverDetailsRequest){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.WAIVER_DETAILS)"
        setUrl(url: url)
        setParameters(parameters: makeDictionary(waiverDetailsRequest))
        super.makeRequest(method: .POST)
    }
    
    func saveWaiverDetails(saveWaiverDetailsRequest:SaveWaiverDetailsRequest){
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.SAVE_WAIVER_DETAILS)"
        setUrl(url: url)
        setParameters(parameters: makeDictionary(saveWaiverDetailsRequest))
        super.makeRequest(method: .POST)
    }
    
    func ReferFriend(referFriendRequest:ReferFriendRequest){
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.REFER_FRIEND)"
        setUrl(url: url)
        setParameters(parameters: makeDictionary(referFriendRequest))
        super.makeRequest(method: .POST)
    }
    
}
