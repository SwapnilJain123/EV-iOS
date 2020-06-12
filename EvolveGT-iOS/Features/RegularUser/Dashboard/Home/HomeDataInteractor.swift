//
//  HomeDataInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 04/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation

protocol HomeViewDelegate : BaseViewDelegate{

    func didFetchDetails(profileData : ProfileData?)
}
class HomeDataInteractor : BaseInteractor{
    var delegate : HomeViewDelegate?
    
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
                            ($0.eventDate?.isEalierThanToday() ?? false)
                        })
                        
                        let upComingEvents = sortedEvents?.filter({
                            !($0.eventDate?.isEalierThanToday() ?? false)
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
            self.delegate?.didFetchDetails(profileData: self.profileData)
        }
        profileApi.fetchCreditHistory(userId: AppEngine.sharedInstance.userID)
    }
}
