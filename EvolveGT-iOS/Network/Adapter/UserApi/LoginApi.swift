//
//  LoginApi.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class LoginApi : BaseApiAdapter{
    
    
    func setCompletionHandler( completionHandler : @escaping (Any?, ApiError? )-> Void){
        self.completionHandler = completionHandler
    }
    
    func doLogin(email: String, password: String ){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.LOGIN)"
        setUrl(url: url)
        
       
        let loginRequest = LoginRequest(emailLogin: email, passwordLogin: password, remember: true)
        setParameters(parameters: makeDictionary(loginRequest))
        
        super.makeRequest(method: .POST)
    }
    
    override func postDecodedResponse(_ jsonResponse: Data) {
        Log.i(jsonResponse)
        let loginResponse = decodeFromJson(jsonResponse, modelType: LoginResponse.self)
        
        if completionHandler != nil {
            completionHandler!(loginResponse, nil)
        }
    }
    
    override func didFail(error: ApiError) {
        super.didFail(error: error)
        Log.e(error)
        if completionHandler != nil {
            completionHandler!(nil, error)
        }
    }
}
