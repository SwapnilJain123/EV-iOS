//
//  HomeDataInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 04/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import Alamofire

protocol HomeViewDelegate{
    
    func didFetchDetails(profileData : ProfileData?, sections : [HomeSection])
    func didFetchCoachDuties(assignedEvents : AssignedDuty)
    
}

protocol NotificationDelegate {
    func didGetNotificaitonData(notificationData : NotificationListResponse?)
    func didFailToGetNotificaitonData()
}


protocol AgreementAcceptanceDelegate{
    func requestToAcceptPolicies(agreement : AgreementStatus)
    func userHasAcceptedConditions()
}
class HomeDataInteractor : BaseInteractor{
   
    var homeViewDelegate : HomeViewDelegate?
    var notificationDelegate : NotificationDelegate?
    var agreementStatusDelegate : AgreementAcceptanceDelegate?
    var logoutAPIResponseDelegate : LogoutAPIResponseDelegate?

    var profileData = ProfileData()
    
    func fetchUserDetails() {
        delegate?.showProgressIndicator(message: LoadingIndicatorMessages.loadingProfileData)
        let profileApi = ProfileApi()
        profileApi.setCompletionHandler{ response, error in
            
            if error == nil{
                Log.i("User details fetched Success - ")
                if let userDetailsResponse = self.decodeFromJson(response!, modelType: UserDetailsResponse.self){
                    self.delegate?.hideEmptyPageError()
                    if userDetailsResponse.userDetails == nil{
                        self.delegate?.hideProgressIndicator()
                        self.delegate?.showEmptyPageError(message: ErrorMessages.genericError)
                    }else{
                        self.profileData.create(with: userDetailsResponse.userDetails!)
                        AppEngine.sharedInstance.userDetails = userDetailsResponse.userDetails
                        AppEngine.sharedInstance.currentUser?.role = userDetailsResponse.userDetails?.evRole ?? "Guest"
                        self.fetchEventHistory()
                    }
                    
                }else{
                    self.delegate?.hideProgressIndicator()
                    Log.i("Api Error - \(String(describing: error?.errorMessage)) ")
                    self.delegate?.showEmptyPageError(message: error?.errorMessage ?? "")
                }
            }else{
                self.delegate?.hideProgressIndicator()
                Log.i("Api Error - \(String(describing: error?.errorMessage)) ")
                self.delegate?.showEmptyPageError(message: error!.errorMessage)
            }
        }
        profileApi.fetchUserDetails(userId: AppEngine.sharedInstance.userID)
    }
    
    func getNotificationList(page: Int) {
        delegate?.showProgressIndicator(message: LoadingIndicatorMessages.loadingNotificationList)
        let profileApi = ProfileApi()
        profileApi.setCompletionHandler{ response, error in
            self.delegate?.hideProgressIndicator()
            if error == nil{
                Log.i("Notification list fetch Success - ")
                if let notificationList = self.decodeFromJson(response!, modelType: NotificationListResponse.self){
                    self.delegate?.hideEmptyPageError()
                    if notificationList.results == nil{
                        self.delegate?.hideProgressIndicator()
                        self.delegate?.showEmptyPageError(message: ErrorMessages.genericError)
                        self.notificationDelegate?.didFailToGetNotificaitonData()
                    }else{
                        self.notificationDelegate?.didGetNotificaitonData(notificationData: notificationList)
                    }
                }else{
                    self.delegate?.hideProgressIndicator()
                    self.notificationDelegate?.didFailToGetNotificaitonData()
                    Log.i("Api Error - \(String(describing: error?.errorMessage)) ")
                    self.delegate?.showEmptyPageError(message: error?.errorMessage ?? "")
                }
            }else{
                self.delegate?.hideProgressIndicator()
                self.notificationDelegate?.didFailToGetNotificaitonData()
                Log.i("Api Error - \(String(describing: error?.errorMessage)) ")
                self.delegate?.showEmptyPageError(message: error!.errorMessage)
            }
        }
        profileApi.getNotificationList(page_number: page)
    }
    
    func userLogOut() {
        delegate?.showProgressIndicator(message: LoadingIndicatorMessages.loadingProfileData)
        let profileApi = ProfileApi()
        profileApi.setCompletionHandler{ response, error in
            
            if error == nil{
                Log.i("User logout Success - ")
                    self.delegate?.hideEmptyPageError()
                    self.logoutAPIResponseDelegate?.logoutUser()
                    self.delegate?.hideProgressIndicator()
                    self.delegate?.showEmptyPageError(message: ErrorMessages.genericError)

            }else{
                self.delegate?.hideProgressIndicator()
                Log.i("Api Error - \(String(describing: error?.errorMessage)) ")
                self.delegate?.showEmptyPageError(message: error!.errorMessage)
            }
        }
        profileApi.userLogOut()
    }
    
    func fetchEventHistory() {
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.USER_EVENT_HISTORY)"

        let parameters: [String: Any] = [
            "is_motoevent": 0,
            "user_id": AppEngine.sharedInstance.userID // Use the current user's ID
        ]
        
        // Show loading indicator
        self.delegate?.showProgressIndicator(message: LoadingIndicatorMessages.loadingEventHistory)
        
        // Make the POST request with Alamofire
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            // Hide loading indicator
            self.delegate?.hideProgressIndicator()
            
            switch response.result {
            case .success(let value):
                Log.i("Event History fetched Success - ")
                
                // Convert the value to Data
                if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: []) {
                    // Decode the response into your model
                    if let decodedResponse = self.decodeFromJson(jsonData, modelType: EventsHistoryResponse.self) {
                        
                        if decodedResponse.enrolledEvents?.isEmpty ?? false{
                            self.profileData.pastEventsCount =  0
                            self.profileData.upComingEventsCount =  0
                            self.profileData.allEventsCount =  0
                            self.profileData.recentPastEvent = nil
                            self.profileData.recentUpComingEvent = nil
                            self.fetchCreditHistory()
                        }else{
                            self.profileData.allEventsCount = decodedResponse.enrolledEvents!.count
                            let sortedEvents = decodedResponse.enrolledEvents?.sorted(by:
                            {
                                if let eventDate = $0.eventDate{
                                    return eventDate < $1.eventDate ?? ""
                                }
                                return false
                            })
                            
                            let pastEvents = sortedEvents?.filter({
                                ($0.eventDate?.isEalierThanToday(dateFormat: .FORMAT_YYYY_MM_DD_HIPHEN) ?? false)
                            })
                            
                            let upComingEvents = sortedEvents?.filter({
                                !($0.eventDate?.isEalierThanToday(dateFormat: .FORMAT_YYYY_MM_DD_HIPHEN) ?? false)
                            })
                            
                            if !(pastEvents?.isEmpty ?? false){
                                self.profileData.recentPastEvent = pastEvents?.last
                            }else{
                                self.profileData.recentPastEvent = nil
                            }
                            if !(upComingEvents?.isEmpty ?? false){
                                self.profileData.recentUpComingEvent = upComingEvents?.last
                            }else{
                                self.profileData.recentUpComingEvent = nil
                            }
                            
                            self.profileData.pastEventsCount = pastEvents?.count ?? 0
                            self.profileData.upComingEventsCount = upComingEvents?.count ?? 0
                            
                            self.fetchCreditHistory()
                        }
                        
                    } else {
                        self.fetchCreditHistory()
                    }
                } else {
                    Log.e("Failed to serialize JSON response.")
                    self.fetchCreditHistory()
                }
                
            case .failure(let error):
                Log.e("Failed to fetch event history: \(error)")
                self.fetchCreditHistory()
            }
        }
    }

//    func fetchEventHistory() {
//        
//        let profileApi = ProfileApi()
//        profileApi.setCompletionHandler{ response, error in
//            
//            if error == nil{
//                Log.i("User details fetched Success - ")
//                if let response = self.decodeFromJson(response!, modelType: EventsHistoryResponse.self){
//                    
//                    if response.enrolledEvents?.isEmpty ?? false{
//                        self.profileData.pastEventsCount =  0
//                        self.profileData.upComingEventsCount =  0
//                        self.profileData.allEventsCount =  0
//                        self.profileData.recentPastEvent = nil
//                        self.profileData.recentUpComingEvent = nil
//                        self.fetchCreditHistory()
//                    }else{
//                        self.profileData.allEventsCount = response.enrolledEvents!.count
//                        let sortedEvents = response.enrolledEvents?.sorted(by:
//                        {
//                            if let eventDate = $0.eventDate{
//                                return eventDate < $1.eventDate ?? ""
//                            }
//                            return false
//                        })
//                        
//                        let pastEvents = sortedEvents?.filter({
//                            ($0.eventDate?.isEalierThanToday(dateFormat: .FORMAT_YYYY_MM_DD_HIPHEN) ?? false)
//                        })
//                        
//                        let upComingEvents = sortedEvents?.filter({
//                            !($0.eventDate?.isEalierThanToday(dateFormat: .FORMAT_YYYY_MM_DD_HIPHEN) ?? false)
//                        })
//                        
//                        if !(pastEvents?.isEmpty ?? false){
//                            self.profileData.recentPastEvent = pastEvents?.last
//                        }else{
//                            self.profileData.recentPastEvent = nil
//                        }
//                        if !(upComingEvents?.isEmpty ?? false){
//                            self.profileData.recentUpComingEvent = upComingEvents?.last
//                        }else{
//                            self.profileData.recentUpComingEvent = nil
//                        }
//                        
//                        self.profileData.pastEventsCount = pastEvents?.count ?? 0
//                        self.profileData.upComingEventsCount = upComingEvents?.count ?? 0
//                        
//                        self.fetchCreditHistory()
//                    }
//                    
//                }
//            }else{
//                self.fetchCreditHistory()
//            }
//        }
//        profileApi.fetchEventHistory(userId: AppEngine.sharedInstance.userID)
//    }
    
    func fetchCreditHistory() {
        
        let profileApi = ProfileApi()
        profileApi.setCompletionHandler{ response, error in
            self.delegate?.hideProgressIndicator()
            if error == nil{
                Log.i("User details fetched Success - ")
                if let response = self.decodeFromJson(response!, modelType: CreditHistoryResponse.self){
                    
                    if response.creditHistoryList?.isEmpty ?? false{
                        self.profileData.recentCreditHistory = nil
                    }else{
                        self.profileData.recentCreditHistory = response.creditHistoryList?.first
                    }
                }
            }
            var sections = [HomeSection]()
            for section in HomeSection.allCases{
                sections.append(section)
            }
            
            if !(AppEngine.sharedInstance.userDetails?.canEnableDuties ?? false){
                sections = sections.filter({$0 != .coachDuties})
            }
            self.homeViewDelegate?.didFetchDetails(profileData: self.profileData, sections: sections)
        }
        profileApi.fetchCreditHistory(userId: AppEngine.sharedInstance.userID)
    }
    
    func fetchCoachDuties(){
        let adminApi = AdminApi()
        self.delegate?.showProgressIndicator(message: LoadingIndicatorMessages.loadingCoachDuties)
        adminApi.setCompletionHandler{ data, error in
            self.delegate?.hideProgressIndicator()
            if error == nil{
                if let response = self.decodeFromJson(data!, modelType: CoachDutyResponse.self){
                    
                    if response.duties == nil{
                        self.delegate?.showAlert(title: "", message: ErrorMessages.eventsNotAssigned)
                    }else{
                        self.homeViewDelegate?.didFetchCoachDuties(assignedEvents: response.duties!)
                    }
                }else{
                    self.delegate?.showAlert(title: "", message: ErrorMessages.genericError)
                }
            }else{
                self.delegate?.showAlert(title: "", message: error?.errorMessage ?? ErrorMessages.genericError)
            }
        }
        adminApi.getCoachDuties(userId: AppEngine.sharedInstance.userID)
        
        
    }
    
    func verifyUserAgreedTerms(){
        let profileApi = ProfileApi()
        
        profileApi.setCompletionHandler{ data, error in
            
            if error == nil{
                if let response = self.decodeFromJson(data!, modelType: UserTermsAcceptanceResponse.self){
                    
                    if response.agrreementStatus?.agreed ?? false == false{
                        self.agreementStatusDelegate?.requestToAcceptPolicies(agreement: response.agrreementStatus!)
                    }
                }else{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 100.0, execute: {
                        self.verifyUserAgreedTerms()
                    })
                }
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 100.0, execute: {
                    self.verifyUserAgreedTerms()
                })
            }
        }
        profileApi.checkTermsAGreementStatus(userId: AppEngine.sharedInstance.userID)
    }
    
    func saveUserAcceptanceStatus(status: Bool){
        let profileApi = ProfileApi()
        self.delegate?.showProgressIndicator(message: LoadingIndicatorMessages.savingAgreement)
        profileApi.setCompletionHandler{ data, error in
            self.delegate?.hideProgressIndicator()
            if error == nil{
                self.agreementStatusDelegate?.userHasAcceptedConditions()
            }else{
                self.delegate?.showErrorToastMessage(message: error?.errorMessage ?? ErrorMessages.genericError)
            }
        }
        profileApi.saveAgreementStatus(userId: AppEngine.sharedInstance.userID, status: status)
    }
    
    func updateDeviceToken(){
        
        if UserDefaultHelper.sharedInstance.getData(key: AppConstants.KEY_DEVICE_TOKEN_STATUS) as? Bool ?? false{
            Log.i("Device Token already Updated!")
            return
        }
        let token = UserDefaultHelper.sharedInstance.getData(key: AppConstants.DEVICE_TOKEN) as? String
        let profileApi = ProfileApi()
        
        profileApi.setCompletionHandler{ data, error in
            if error == nil{
                Log.i("Device Token Updated!")
                UserDefaultHelper.sharedInstance.saveData(key: AppConstants.KEY_DEVICE_TOKEN_STATUS, value: true)
            }else{
                Log.e("Device Token updating failed")
            }
        }
        profileApi.updateDeviceToken(userId: AppEngine.sharedInstance.userID, deviceToken: token)
    }
}
enum HomeSection: Int, CaseIterable{
    case profile
    case coachDuties
    case upcomingEvents
    case pastEvents
    case creditHistory
    case referAFriend
}
