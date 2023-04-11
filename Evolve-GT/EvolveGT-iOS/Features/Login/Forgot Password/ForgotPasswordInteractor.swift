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
    
    var forgotPwdDelegate:ForgotPasswordDelegate?
    
    
    func resetPassword(email:String){
        
        super.delegate = forgotPwdDelegate
        
        if !email.isValidEmail(){
            self.forgotPwdDelegate?.showValidationError(errorMessage: ErrorMessages.invalidEmail)
            return
        }
        
        
        
        let forgotPwdApi = LoginApi()
        
        delegate?.showProgressIndicator(message: LoadingIndicatorMessages.resettingPassword)
        
        forgotPwdApi.setCompletionHandler{ data, error in
            self.delegate?.hideProgressIndicator()
            if error == nil{
                if let response = self.decodeFromJson(data!, modelType: ForgotPasswordResponse.self){
                    self.forgotPwdDelegate?.didResetPassword(message: response.msg ?? "")
                }else{
                    self.forgotPwdDelegate?.showValidationError( errorMessage: ErrorMessages.genericError)
                }
            }else{
                self.forgotPwdDelegate?.showValidationError(errorMessage: error!.errorMessage)
            }
        }
        
        forgotPwdApi.forgotPassword(email: email)
    }
}
