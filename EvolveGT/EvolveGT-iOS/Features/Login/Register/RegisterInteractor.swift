//
//  RegisterInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 23/09/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class RegisterInteractor : BaseInteractor{
    
    let signupRequest = RegistrationRequest()
    
    var handleCreateAccount : ((_ isAdmin: Bool) -> Void)?
    
    var isPasswordValid: Bool{
        
        let predicate = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9]).{6,20}$"
       let passwordCheck = NSPredicate(format: "SELF MATCHES %@", predicate)
        return passwordCheck.evaluate(with: signupRequest.password)
    }
    func validatePersonalData() -> Bool{
        
        if signupRequest.firstname?.isEmpty ?? true{
            return false
        }else if signupRequest.lastname?.isEmpty ?? true{
            return false
        }else if signupRequest.email?.isEmpty ?? true{
            return false
        }else if signupRequest.phone?.isEmpty ?? true{
            return false
        }else if signupRequest.dob?.isEmpty ?? true{
            return false
        }
        
        return true
    }
    
    func validateProfile() -> Bool{
        if signupRequest.skillLevel?.isEmpty ?? true{
            return false
        }else if !isPasswordValid{
            return false
        }else if signupRequest.password != signupRequest.confirmPassword{
            return false
        }
        return true
    }
    
    
    func register(){
        delegate?.showProgressIndicator(message: LoadingIndicatorMessages.creatingAccount)
        
        let api = LoginApi()
        api.setCompletionHandler(completionHandler: {data, error in
            self.delegate?.hideProgressIndicator()
            
            if error == nil && data != nil{
                if let response = self.decodeFromJson(data!, modelType: LoginResponse.self){
                    AppEngine.sharedInstance.saveUserInfo(user: response.currentUser)
                    AppEngine.sharedInstance.saveAuthToken(token: response.token)
                    
                    if let action = self.handleCreateAccount{
                        action(response.currentUser.isAdmin())
                    }
                    
                }else{
                    self.delegate?.showAlert(title: "Error", message: ErrorMessages.genericError)
                }
            }else{
                var errorMessage = ErrorMessages.genericError
                if let apiError = error{
                    errorMessage = apiError.errorMessage
                }
                self.delegate?.showAlert(title: "Error", message: errorMessage)
            }
        })
        api.createAccount(signupRequest: signupRequest)
    }
}
