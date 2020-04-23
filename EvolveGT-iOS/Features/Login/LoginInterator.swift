//
//  LoginInterator.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
protocol LoginViewDelegate : BaseViewDelegate{
    func launchAdminPage()
    func launchUserPage()
    func launchGuestPage()
    
    func showLoginError(errorMessage: String)
    
}

class LoginInteractor : BaseInteractor{
    
    var delegate: LoginViewDelegate?
    
    var email = ""
    var password = ""
    func doLogin(email: String, password: String){
        self.email = email
        self.password = password
        
        if(validate()){
            delegate?.showProgressIndicator(message: LoadingIndicatorMessages.loggingIn)
            let loginApi = LoginApi()
            loginApi.setCompletionHandler{ response, error in
                self.delegate?.hideProgressIndicator()
                if error == nil{
                    Log.i("Login Success - ")
                    if let loginResponse = self.decodeFromJson(response!, modelType: LoginResponse.self){
                        
                        Log.i("Logged In By - \(loginResponse.currentUser.displayName)")
                        AppEngine.sharedInstance.saveUserInfo(user: loginResponse.currentUser)
                        AppEngine.sharedInstance.saveAuthToken(token: loginResponse.token)
                        
                        if loginResponse.currentUser.isAdmin(){
                            self.delegate?.launchAdminPage()
                        }else {
                            self.delegate?.launchUserPage()
                        }
                    }
                }else{
                    Log.i("Login Error - \(String(describing: error?.errorMessage)) ")
                    self.delegate?.showLoginError(errorMessage: error!.errorMessage)
                }
            }
            loginApi.doLogin(email: email, password: password)
        }
    }
    
    func validate() -> Bool{
        
        if email.isEmpty || !email.isValidEmail(){
            delegate?.showLoginError(errorMessage: MessageConstants.KPromptMsgEnterValidEmail)
            return false
        }else if password.isEmpty{
            delegate?.showLoginError(errorMessage: MessageConstants.KPromptMsgEnterPassword)
            return false
        }
        
        return true
    }
    
}
