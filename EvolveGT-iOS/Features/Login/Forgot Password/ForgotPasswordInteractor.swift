//
//  ForgotPasswordInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 10/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
protocol ForgotPasswordDelegate:BaseViewDelegate {
    
    func didResetPassword(message:String)
    func showValidationError(errorMessage:String)
}

class ForgotPasswordInteractor:BaseInteractor{
    
    var delegate:ForgotPasswordDelegate?
    
    
    func resetPassword(email:String){
        
        if !email.isValidEmail(){
            self.delegate?.showValidationError(errorMessage: ErrorMessages.invalidEmail)
            return
        }
        
        
        
        let forgotPwdApi = LoginApi()
        
        delegate?.showProgressIndicator(message: LoadingIndicatorMessages.resettingPassword)
        
        forgotPwdApi.setCompletionHandler{ data, error in
            self.delegate?.hideProgressIndicator()
            if error == nil{
                if let response = self.decodeFromJson(data!, modelType: ForgotPasswordResponse.self){
                    self.delegate?.didResetPassword(message: response.msg ?? "")
                }else{
                    self.delegate?.showValidationError( errorMessage: ErrorMessages.genericError)
                }
            }else{
                self.delegate?.showValidationError(errorMessage: error!.errorMessage)
            }
        }
        
        forgotPwdApi.forgotPassword(email: email)
    }
}
