//
//  EnrolledEventsInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 09/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import Alamofire

protocol EnrolledEventsViewDelegate{
    func didFetchAllEvents(events : [EnrolledEvent])
    func didFetchPastEvents(events : [EnrolledEvent]?)
    func didFetchUpcomingEvents(events : [EnrolledEvent]?)
    
    func eventsEmpty()
    func reloadCurrentIndex()
}

class EnrolledEventsInteractor: BaseInteractor {
    
    var enrolledEventsDelegate: EnrolledEventsViewDelegate?
    
    
    func fetchEventHistory() {
        // API URL
//        let url = "https://tracknutts.com/ontrack-api/public/app/v3/user/allEvents"
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.USER_EVENT_HISTORY)"

        // Parameters for the request
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
                        
                        if decodedResponse.enrolledEvents?.isEmpty ?? false {
                            self.enrolledEventsDelegate?.eventsEmpty()
                        } else {
                            // Sort events by event date
                            let sortedEvents = decodedResponse.enrolledEvents?.sorted(by: {
                                if let eventDate = $0.eventDate {
                                    return eventDate < $1.eventDate ?? ""
                                }
                                return false
                            })
                            
                            // Separate past and upcoming events
                            let pastEvents = sortedEvents?.filter({
                                ($0.eventDate?.isEalierThanToday(dateFormat: .FORMAT_YYYY_MM_DD_HIPHEN) ?? false)
                            })
                            let upComingEvents = sortedEvents?.filter({
                                !($0.eventDate?.isEalierThanToday(dateFormat: .FORMAT_YYYY_MM_DD_HIPHEN) ?? false)
                            })
                            
                            // Delegate the events
                            self.enrolledEventsDelegate?.didFetchAllEvents(events: sortedEvents!)
                            self.enrolledEventsDelegate?.didFetchPastEvents(events: pastEvents)
                            self.enrolledEventsDelegate?.didFetchUpcomingEvents(events: upComingEvents!)
                        }
                    } else {
                        self.enrolledEventsDelegate?.eventsEmpty()
                    }
                } else {
                    Log.e("Failed to serialize JSON response.")
                    self.enrolledEventsDelegate?.eventsEmpty()
                }
                
            case .failure(let error):
                Log.e("Failed to fetch event history: \(error)")
                self.enrolledEventsDelegate?.eventsEmpty()
            }
            
            // Reload the current index regardless of success or failure
            self.enrolledEventsDelegate?.reloadCurrentIndex()
        }
    }
    
    func cancelEvent(itemID: Int){
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
