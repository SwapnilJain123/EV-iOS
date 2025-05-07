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
    
    func createAccount(signupRequest: RegistrationRequest){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.CREATE_ACCOUNT)"
        setUrl(url: url)
        
        setParameters(parameters: makeDictionary(signupRequest))
        print(makeDictionary(signupRequest.gender))
        super.makeRequest(method: .POST)
    }
    
    func sendOtpForEmailVerify(OTPSendRequest: sendOTPRequest){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.SEND_OTP_EMAILVERIFY)"
        setUrl(url: url)
        
        setParameters(parameters: makeDictionary(OTPSendRequest))
        super.makeRequest(method: .POST)
    }

    func verifyOtp(verifyOTPRequest: verifyOTPRequest){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.OTP_VERIFY)"
        setUrl(url: url)
        
        setParameters(parameters: makeDictionary(verifyOTPRequest))
        super.makeRequest(method: .POST)
    }

    func checkForEmailVerify() {
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.FETCH_THEME)"
        setUrl(url: url)
        
        //setParameters(parameters: makeDictionary(OTPSendRequest))
        super.makeRequest(method: .GET)
    }
    
}
