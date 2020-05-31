//
//  LoginApi.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class LoginApi : BaseApiAdapter{
    
    
    func doLogin(email: String, password: String ){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.LOGIN)"
        setUrl(url: url)
        let loginRequest = LoginRequest(emailLogin: email, passwordLogin: password, remember: true)
        setParameters(parameters: makeDictionary(loginRequest))
        super.makeRequest(method: .POST)
    }
    
    func forgotPassword(email: String){
           
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.FORGOT_PASSWORD)"
           setUrl(url: url)
           let forgotRequest = ForgotPasswordRequest(userEmail: email)
           setParameters(parameters: makeDictionary(forgotRequest))
           super.makeRequest(method: .POST)
       }
    
    
}
