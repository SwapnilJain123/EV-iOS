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
   
    func fetchEnrolledMembership(userId: String){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.USER_MEMBERSHIP)"
        let request = UserMemberShipRequest(userId: userId)
        setUrl(url: url)
        setParameters(parameters: makeDictionary(request))
        super.makeRequest(method: .POST)
    }
    
    func updateProfile(request: ProfileUpdateRequest){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.UPDATE_PROFILE)"
        setUrl(url: url)
        setParameters(parameters: makeDictionary(request))
        super.makeRequest(method: .POST)
    }
    
    func updateBilllingAdress(request: BillingAdressUpdateRequest){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.UPDATE_PROFILE)"
        setUrl(url: url)
        setParameters(parameters: makeDictionary(request))
        super.makeRequest(method: .POST)
    }
    
    func updateShippingAdress(request: ShippingAdressUpdateRequest){
           
           let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.UPDATE_PROFILE)"
           setUrl(url: url)
           setParameters(parameters: makeDictionary(request))
           super.makeRequest(method: .POST)
       }
    
    func updateProfilePicture(userId: String, imageUploadItem: UploadItem){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.UPDATE_PROFILE_IMAGE)"
        setUrl(url: url)
        setParameters(parameters: ["user_id":userId])
        clearUploadItems()
        appendUploadItem(uploadItem: imageUploadItem)
        super.makeRequest(method: .POST)
    }
    func checkTermsAGreementStatus(userId: String){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.CHECK_TnC_STATUS)"
        setUrl(url: url)
        setParameters(parameters: makeDictionary(UserDataSerialRequest(userID: userId)))
        super.makeRequest(method: .POST)
    }
    func saveAgreementStatus(userId: String, status: Bool){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.SAVE_TnC_STATUS)"
        setUrl(url: url)
        setParameters(parameters: makeDictionary(SaveUserAgreementRequest(userID: userId, agreementStatus: status)))
        super.makeRequest(method: .POST)
    }
    
    func fetchNotificationPreferences(userId: String){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.NOTIFICATION_TYPES)"
        setUrl(url: url)
        setParameters(parameters: makeDictionary(UserDataUserIdRequest(userID: userId)))
        super.makeRequest(method: .POST)
    }
    
    func updateNotificationSettings(request: NotificationPreferenceUpdateRequest){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.UPDATE_NOTIFICATION_PREF)"
        setUrl(url: url)
        setParameters(parameters: makeDictionary(request))
        super.makeRequest(method: .POST)
    }
}
