//
//  EnrolledEventsInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 09/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation

protocol EnrolledEventsViewDelegate{
    func didFetchAllEvents(events : [EnrolledEvent])
    func didFetchPastEvents(events : [EnrolledEvent]?)
    func didFetchUpcomingEvents(events : [EnrolledEvent]?)
    
    func eventsEmpty()
    func reloadCurrentIndex()
}

class EnrolledEventsInteractor: BaseInteractor {
    
    var enrolledEventsDelegate: EnrolledEventsViewDelegate?
     var delegate: BaseViewDelegate?
    
    func fetchEventHistory() {
        
        let profileApi = ProfileApi()
        self.delegate?.showProgressIndicator(message: LoadingIndicatorMessages.loadingEventHistory)
        profileApi.setCompletionHandler{ response, error in
           
            self.delegate?.hideProgressIndicator()
            if error == nil{
                Log.i("Event History fetched Success - ")
                if let response = self.decodeFromJson(response!, modelType: EventsHistoryResponse.self){
                    
                    if response.enrolledEvents?.isEmpty ?? false{
                        self.enrolledEventsDelegate?.eventsEmpty()
                    }else{
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
                        
                        self.enrolledEventsDelegate?.didFetchAllEvents(events: sortedEvents!)
                        self.enrolledEventsDelegate?.didFetchPastEvents(events: pastEvents)
                        self.enrolledEventsDelegate?.didFetchUpcomingEvents(events: upComingEvents!)
                        
                    }
                    
                }
            }else{
                self.enrolledEventsDelegate?.eventsEmpty()
            }
            
            self.enrolledEventsDelegate?.reloadCurrentIndex()
        }
        profileApi.fetchEventHistory(userId: AppEngine.sharedInstance.userID)
    }
    
    func cancelEvent(itemID: String){
         self.delegate?.showProgressIndicator(message: LoadingIndicatorMessages.cancellingEvent)
        let profileApi = ProfileApi()
        var request = CancelEventRequest()
        request.userId = AppEngine.sharedInstance.userID
        request.skillLevel = AppEngine.sharedInstance.currentUser?.skillLevel
        request.orderItemId = itemID
        
        profileApi.setCompletionHandler{data, error in
            self.delegate?.hideProgressIndicator()
            if error == nil{
                self.delegate?.showSuccessToastMessage(message: SuccessMessages.eventCancelled)
            }else{
                self.delegate?.showErrorToastMessage(message: error?.errorMessage ?? ErrorMessages.genericError)
            }
        }
        profileApi.cancelEvent(request: request)
    }
}
