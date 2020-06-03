//
//  ProfileApi.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 04/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class ProfileApi : BaseApiAdapter{
    
    func fetchUserDetails(userId: String){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.USER_DETAILS)"
        setUrl(url: url)
        let request = UserDetailsRequest(userID: userId)
        setParameters(parameters: makeDictionary(request))
        super.makeRequest(method: .POST)
    }
    
    func fetchEventHistory(userId: String){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.USER_EVENT_HISTORY)"
        setUrl(url: url)
        let request = EventHistoryRequest(userID: userId, isMotoevent: AppEngine.sharedInstance.appMode.rawValue)
        setParameters(parameters: makeDictionary(request))
        super.makeRequest(method: .POST)
    }
    
    func fetchCreditHistory(userId: String){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.USER_CREDIT_HISTORY)"
        setUrl(url: url)
        let request = CreditHistoryRequest(userID: userId)
        setParameters(parameters: makeDictionary(request))
        super.makeRequest(method: .POST)
    }
    
    func cancelEvent(request: CancelEventRequest){
           
           let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.CANCEL_EVENT)"
           setUrl(url: url)
           setParameters(parameters: makeDictionary(request))
           super.makeRequest(method: .POST)
       }
    
    func changePassword(userId:String , newPasssword:String , currentPassword:String){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.CHANGE_PASSWORD)"
        setUrl(url: url)
        var request = PasswordChangeRequest()
        request.userID = userId
        
        var passwordRequestBody = PasswordRequestBody()
        
        
        passwordRequestBody.confirmPassword = newPasssword
        passwordRequestBody.currentpassword = currentPassword
        passwordRequestBody.password = newPasssword
        
        request.passwordRequestBody = passwordRequestBody
        
        setParameters(parameters: makeDictionary(request))
        
        super.makeRequest(method: .POST)
        
        
    }
    
    
    
    
}
