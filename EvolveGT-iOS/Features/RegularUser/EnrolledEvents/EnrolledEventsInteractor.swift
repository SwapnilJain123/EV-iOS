//
//  EnrolledEventsInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 09/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
protocol EnrolledEventsViewDelegate : BaseViewDelegate{
    func didFetchAllEvents(events : [EnrolledEvent])
    func didFetchPastEvents(events : [EnrolledEvent]?)
    func didFetchUpcomingEvents(events : [EnrolledEvent]?)
    
    func eventsEmpty()
    func reloadCurrentIndex()
}

class EnrolledEventsInteractor: BaseInteractor {
    
    var delegate: EnrolledEventsViewDelegate?
    
    func fetchEventHistory() {
        
        let profileApi = ProfileApi()
        self.delegate?.showProgressIndicator(message: LoadingIndicatorMessages.loadingEventHistory)
        profileApi.setCompletionHandler{ response, error in
           
            self.delegate?.hideProgressIndicator()
            if error == nil{
                Log.i("Event History fetched Success - ")
                if let response = self.decodeFromJson(response!, modelType: EventsHistoryResponse.self){
                    
                    if response.enrolledEvents?.isEmpty ?? false{
                        self.delegate?.eventsEmpty()
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
                        
                        self.delegate?.didFetchAllEvents(events: sortedEvents!)
                        self.delegate?.didFetchPastEvents(events: pastEvents)
                        self.delegate?.didFetchUpcomingEvents(events: upComingEvents!)
                        
                    }
                    
                }
            }else{
                self.delegate?.eventsEmpty()
            }
            
            self.delegate?.reloadCurrentIndex()
        }
        profileApi.fetchEventHistory(userId: AppEngine.sharedInstance.userID)
    }
}
