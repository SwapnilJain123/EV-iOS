//
//  HomeDataInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 04/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation

protocol HomeViewDelegate{
    
    func didFetchDetails(profileData : ProfileData?, sections : [HomeSection])
    func didFetchCoachDuties(assignedEvents : [AssignedEvent])
    
}
protocol AgreementAcceptanceDelegate{
    func requestToAcceptPolicies(agreement : AgreementStatus)
    func userHasAcceptedConditions()
}
class HomeDataInteractor : BaseInteractor{
   
    var homeViewDelegate : HomeViewDelegate?
    var agreementStatusDelegate : AgreementAcceptanceDelegate?
    
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
                        self.fetchEventHistory()
                    }
                    
                }else{
                    self.delegate?.hideProgressIndicator()
                    Log.i("Api Error - \(String(describing: error?.errorMessage)) ")
                    self.delegate?.showEmptyPageError(message: error!.errorMessage)
                }
            }else{
                self.delegate?.hideProgressIndicator()
                Log.i("Api Error - \(String(describing: error?.errorMessage)) ")
                self.delegate?.showEmptyPageError(message: error!.errorMessage)
            }
        }
        profileApi.fetchUserDetails(userId: AppEngine.sharedInstance.userID)
    }
    func fetchEventHistory() {
        
        let profileApi = ProfileApi()
        profileApi.setCompletionHandler{ response, error in
            
            if error == nil{
                Log.i("User details fetched Success - ")
                if let response = self.decodeFromJson(response!, modelType: EventsHistoryResponse.self){
                    
                    if response.enrolledEvents?.isEmpty ?? false{
                        self.profileData.pastEventsCount =  0
                        self.profileData.upComingEventsCount =  0
                        self.profileData.allEventsCount =  0
                        
                        self.profileData.recentPastEvent = nil
                        self.profileData.recentUpComingEvent = nil
                        
                        self.fetchCreditHistory()
                    }else{
                        self.profileData.allEventsCount = response.enrolledEvents!.count
                        let sortedEvents = response.enrolledEvents?.sorted(by:
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
                    
                }
            }else{
                self.fetchCreditHistory()
            }
        }
        profileApi.fetchEventHistory(userId: AppEngine.sharedInstance.userID)
    }
    
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
            
            if !(AppEngine.sharedInstance.currentUser?.isCoach() ?? false){
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
                    
                    if response.assignedEvents?.count ?? 0 == 0{
                        self.delegate?.showAlert(title: "", message: ErrorMessages.eventsNotAssigned)
                    }else{
                        self.homeViewDelegate?.didFetchCoachDuties(assignedEvents: response.assignedEvents!)
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
