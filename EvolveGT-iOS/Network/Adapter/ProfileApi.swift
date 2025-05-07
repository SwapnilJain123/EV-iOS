//
//  ProfileApi.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 04/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class ProfileApi : BaseApiAdapter{
    
    func fetchUserDetails(userId: Int){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.USER_DETAILS)"
        setUrl(url: url)
        var request = UserDetailsRequest()
        request.isMoto = AppEngine.sharedInstance.isEvApp() ? 0 : 1
        request.userID = userId
        setParameters(parameters: makeDictionary(request))
        super.makeRequest(method: .POST)
    }
    func getNotificationList(page_number: Int){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.NOTIFICATION_LIST)"
        setUrl(url: url)
        var request = NotificationListRequest()
        request.pageNumber = page_number
        setParameters(parameters: makeDictionary(request))
        super.makeRequest(method: .POST)
    }

    
    func userLogOut(){
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.USER_LOGOUT)"
        setUrl(url: url)
        super.makeRequest(method: .GET)
    }

    func fetchEventHistory(userId: Int){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.USER_EVENT_HISTORY)"
        setUrl(url: url)
        let request = EventHistoryRequest(userID: userId, isMotoevent: AppEngine.sharedInstance.appMode.rawValue)
        setParameters(parameters: makeDictionary(request))
        super.makeRequest(method: .POST)
    }
    
    func fetchCreditHistory(userId: Int){
        
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
    
    func changePassword(userId: Int , newPasssword:String , currentPassword:String){
        
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
    
    func fetchEnrolledMembership(userId: Int){
        
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
    
    func updateProfilePicture(userId: Int, imageUploadItem: UploadItem){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.UPDATE_PROFILE_IMAGE)"
        setUrl(url: url)
        setParameters(parameters: ["user_id":userId])
        clearUploadItems()
        appendUploadItem(uploadItem: imageUploadItem)
        super.makeRequest(method: .POST)
    }
    func checkTermsAGreementStatus(userId: Int){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.CHECK_TnC_STATUS)"
        setUrl(url: url)
        var request = UserDataSerialRequest()
        request.userID = userId
        request.isMoto = AppEngine.sharedInstance.isEvApp() ? 0 : 1
        setParameters(parameters: makeDictionary(request))
        super.makeRequest(method: .POST)
    }
    func saveAgreementStatus(userId: Int, status: Bool){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.SAVE_TnC_STATUS)"
        setUrl(url: url)
        setParameters(parameters: makeDictionary(SaveUserAgreementRequest(userID: userId, agreementStatus: status)))
        super.makeRequest(method: .POST)
    }
    
    func fetchNotificationPreferences(userId: Int){
        
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
    func updateDeviceToken(userId: Int?, deviceToken: String? ){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.UPDATE_DEVICE_TOKEN)"
        setUrl(url: url)
        let request = DeviceTokenRequest(userId: userId, token: deviceToken, deviceType: "iOS")
        setParameters(parameters: makeDictionary(request))
        super.makeRequest(method: .POST)
    }
    
    func transferCredit(transferCreditRequest:TransferAmountRequest){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.TRANSFER_AMOUNT)"
        setUrl(url: url)
        setParameters(parameters: makeDictionary(transferCreditRequest))
        super.makeRequest(method: .POST)
    }
    
    func viewPassport(passportId: Int){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.VIEW_PASSPORT)"
        setUrl(url: url)
        setParameters(parameters: ["passport_id":passportId])
        super.makeRequest(method: .POST)
    }
    
    func showPassport(passportId: Int){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.SHOW_PASSPORT)"
        setUrl(url: url)
        setParameters(parameters: ["passport_id":passportId])
        super.makeRequest(method: .POST)
    }

    func uploadPassport(userId: Int, imageUploadItem: UploadItem, signature: Data, eventId: Int){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.SAVE_PASSPORT)"
        setUrl(url: url)
        
        var encodedSignature = signature.base64EncodedString()
        encodedSignature = "\(AppConstants.ImageTag)\(encodedSignature)"
        
        setParameters(parameters: ["user_id":userId, "event_id":eventId, "signature":encodedSignature, "agree":"1"])
        clearUploadItems()
        appendUploadItem(uploadItem: imageUploadItem)
        super.makeRequest(method: .POST)
    }
    
    func updateEmergencyContact(userId: Int, contact: EmergencyContact){
        var request = EmergencyContactRequest()
        request.userID = userId
        request.emergencyFirstName = contact.firstName
        request.emergencyLastName = contact.lastName
        request.emergencyPhone = contact.phone
        request.emergencyRelationship = contact.relationShip
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.UPDATE_EMERGENCY_CONTACT)"
        setUrl(url: url)
        setParameters(parameters: makeDictionary(request))
        super.makeRequest(method: .POST)
    }
}
