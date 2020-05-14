//
//  EventsInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 12/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
protocol EventListViewDelegate : BaseViewDelegate{
    func didFetchEvents(events : [Event]?)
    func presentEventTypeFilterOptions(options : [String])
    func presentMonthFilterOptions(options : [String])
}
class EventsInteractor :BaseInteractor{
    
    var eventListDelegate : EventListViewDelegate?
    var events = [Event]()
    func fetchEventList(){
   
        eventListDelegate?.showProgressIndicator(message: LoadingIndicatorMessages.loadingEvents)
        let eventsApi  = EventsApi()
      
        
        eventsApi.setCompletionHandler{ response, error in
            self.eventListDelegate?.hideProgressIndicator()
            if error == nil{
                Log.i("Event Paticipants Request Success - ")
                if let eventsResponse = self.decodeFromJson(response!, modelType: EventListResponse.self){
                    
                    if eventsResponse.events?.count == 0{
                        self.eventListDelegate?.showEmptyPageError(message: ErrorMessages.emptyEventList)
                    }else{
                        self.events = eventsResponse.events!
                        self.eventListDelegate?.didFetchEvents(events: eventsResponse.events)
                    }
                    
                }else{
                     self.eventListDelegate?.showEmptyPageError(message: error!.errorMessage)
                }
            }else{
                Log.i("Api Error - \(String(describing: error?.errorMessage)) ")
                self.eventListDelegate?.showEmptyPageError(message: error!.errorMessage)
            }
        }
       
        if AppEngine.sharedInstance.isEvApp(){
            eventsApi.fetchEvolveEventList()
        }else{
            eventsApi.fetchMotoEventList()
        }
    }
    
    
    func shouldEnableAddToCart(event: Event) -> Bool{
        
        if event.isMotoEvent{
            return false
        }else{
            if event.activeHostings?.count == 0{
                return !(event.isCancelled ?? false)
            }else{
                return true
            }
        }
        
    }
    func filterItems(with filterType: FilterType) {
        switch filterType {
        
        case .month:
            Log.d("Filter By Month")
            
            let sortedEvents = events.sorted(by: { $0.eventDate! < $1.eventDate ?? "" })
            var eventMonths = sortedEvents.compactMap { $0.eventDate }.map{
                $0.formattedDate(outputFormat: .FORMAT_YYYY_MM)
            }.unique().sorted(by: <)
            eventMonths = eventMonths.map{
                let dateString = "\($0) 15"
                 return dateString.formattedDate(outputFormat: .FORMAT_MMM_YYYY)
            }
            self.eventListDelegate?.presentMonthFilterOptions(options: eventMonths)
        case .eventType:
            Log.d("Filter By Event")
            let eventTypes = events.compactMap { $0.eventType }.unique().sorted(by: <)
            self.eventListDelegate?.presentEventTypeFilterOptions(options: eventTypes)
        case .none:
            Log.d("Filter Clear")
            self.eventListDelegate?.didFetchEvents(events: events)
        case .trainingType:
             Log.d("Ignored ")
        }
    }
    
    func filterBy(_ query:String, _ filterType: FilterType){
        if query.isEmpty && filterType != .none{
            return
        }
        
        var filteredList = [Event]()
        switch filterType {
        case .eventType:
            filteredList = self.events.filter {
                $0.eventType?.lowercased() == query.lowercased()
                
            }
        case .month:
            filteredList = self.events.filter { $0.eventDate?.formattedDate(outputFormat: .FORMAT_MMM_YYYY).lowercased() == query.lowercased()
            }
        case .none:
            filteredList = self.events.filter { _ in true
            }
        case .trainingType:
            Log.d("Ignored!")
        }
        self.eventListDelegate?.didFetchEvents(events: filteredList)
        
    }
    
}
