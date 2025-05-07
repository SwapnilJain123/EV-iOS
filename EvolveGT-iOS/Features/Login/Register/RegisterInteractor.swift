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
    let otpSendRequest = sendOTPRequest()
    let verifyOtpRequest = verifyOTPRequest()

    var handleCreateAccount : ((_ isAdmin: Bool) -> Void)?
    var handleSendOTP : ((_ isSucess: Bool) -> Void)?
    var handleVerifyOTP : ((_ isSucess: Bool) -> Void)?

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
            
            if error == nil && data != nil {
                if let response = self.decodeFromJson(data!, modelType: LoginResponse.self){
                    AppEngine.sharedInstance.saveUserInfo(user: response.currentUser)
                    AppEngine.sharedInstance.saveAuthToken(token: response.token)
                    if let action = self.handleCreateAccount{
                        action(response.currentUser.isAdmin())
                    }
                } else {
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
    
    func otpSendForEmailVerification() {
        delegate?.showProgressIndicator(message: LoadingIndicatorMessages.sendingOTP)
        
        let api = LoginApi()
        api.setCompletionHandler(completionHandler: { data, error in
            self.delegate?.hideProgressIndicator()
            
            if error == nil && data != nil {
                if let response = self.decodeFromJson(data!, modelType: OTPSendResponse.self){
                    self.delegate?.showAlert(title: "Alert!", message: response.msg ?? "")
                    if let action = self.handleSendOTP{
                        action(response.status == 1)
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
        api.sendOtpForEmailVerify(OTPSendRequest: otpSendRequest)
    }
    
    func otpVerification() {
        delegate?.showProgressIndicator(message: LoadingIndicatorMessages.verifyOTP)
        
        let api = LoginApi()
        api.setCompletionHandler(completionHandler: {data, error in
            self.delegate?.hideProgressIndicator()
            
            if error == nil && data != nil {
                if let response = self.decodeFromJson(data!, modelType: verifyOTPResponse.self){
//                    self.delegate?.showAlert(title: "Alert!", message: response.msg ?? "")
                    if let action = self.handleVerifyOTP{
                        action(response.status == 1)
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
        api.verifyOtp(verifyOTPRequest: verifyOtpRequest)
    }
    
    func checkEmailVerification(completionBlock: @escaping(Result<ThemeData, Error>) -> Void) {
        let url: String = "\(ApiConstants.BASE_URL)\(UserApiConstants.FETCH_THEME)"
        ApiClient().callAPIFor(strURL: url, requestType: .get, parameter: [:]) { responseData in
            do {
                let decodedResponse = try JSONDecoder().decode(ThemeResponse.self, from: responseData)
                completionBlock(.success(decodedResponse.result))
            } catch {
                completionBlock(.failure(error))
            }
        }
    }
}
