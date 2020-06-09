//
//  ChangePasswordInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 18/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation



protocol ChangePasswordDelehate:BaseViewDelegate {
    func changePasswordMessage(message:String)
}
class ChangePasswordInteractor:BaseInteractor {
   
    var delegate : ChangePasswordDelehate?
   
    func changePassword(_ currentPassword: String, _ newPassword: String, _ confirmPassword: String){
        
        if currentPassword.isEmpty(){
            
            self.delegate?.changePasswordMessage(message: ErrorMessages.errorEmptyCurrentPassword)
            
           
        }else if newPassword.isEmpty(){
            self.delegate?.changePasswordMessage(message: ErrorMessages.errorEmptyPassword)
            
        }else if newPassword != confirmPassword{
            self.delegate?.changePasswordMessage(message: ErrorMessages.errorConfirmPassword)
            
            
        }else{
            
           let profileApi = ProfileApi()
            self.delegate?.showProgressIndicator(message: LoadingIndicatorMessages.resettingPassword)
            
           profileApi.setCompletionHandler{data,error in
            
            self.delegate?.hideProgressIndicator()
                
                if error == nil{
                    if let response = self.decodeFromJson(data!, modelType: ETResponse.self) {
                        self.delegate?.showSuccessToastMessage(message: response.msg ?? SuccessMessages.passwordChanged)
                    }else{
                        self.delegate?.showErrorToastMessage(message: ErrorMessages.genericError)
                    }
                }else{
                    self.delegate?.showErrorToastMessage(message: error?.errorMessage ?? ErrorMessages.genericError)
                }
            
            }
            
            profileApi.changePassword(userId: AppEngine.sharedInstance.userID, newPasssword: newPassword, currentPassword: currentPassword)
            
           
        }
        
        
    }
}
