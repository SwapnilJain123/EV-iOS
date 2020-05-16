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

protocol EventDetailsDelegate : BaseViewDelegate{
    func didFetchEventDetails(_ eventDetails : EventDetails, sections :[EventsInteractor.EventDetailsSections] )
}
class EventsInteractor :BaseInteractor{
    
    enum EventDetailsSections: Int{
        case basic
        case rentals
        case trainings
        case about
    }
    var eventListDelegate : EventListViewDelegate?
    var eventDetailsDelegate : EventDetailsDelegate?
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
        
        (event.activeHostings?.count ?? 0 > 0) || !(event.isMotoEvent ?? false && event.isCancelled ?? false)
        
        
        
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
    
    func addEventToCart(_ event: Event){
        if event.isMotoEvent{
            //Ignore adding moto events here
            return
        }
        
        eventListDelegate?.showProgressIndicator(message: LoadingIndicatorMessages.addingEventToCart)
        var request = EventCartRequest()
        request.eventSlug = event.slug
        request.eventDate = event.eventDate;
        request.eventSlug = event.slug;
        request.eventPrice = event.price;
        request.serial = AppEngine.sharedInstance.userID
        request.role = AppEngine.sharedInstance.userRole
        request.title = event.title;
        request.eventCouponCode = event.couponCode;
        
        let cartApi = CartApi()
        cartApi.setCompletionHandler{ response, error in
            self.eventListDelegate?.hideProgressIndicator()
            if error == nil{
                self.eventListDelegate?.showSuccessToastMessage(message: SuccessMessages.eventAddedToCart)
            }else{
                Log.i("Api Error - \(String(describing: error?.errorMessage)) ")
                self.eventListDelegate?.showErrorToastMessage(message: error!.errorMessage)
            }
        }
        cartApi.addEvolveEventToCart(eventRequest: request)
    }
    
    //Mark- Event Details
    
    func fetchEventDetails(slug: String, isMotoEvent: Bool = false){
        eventDetailsDelegate?.showProgressIndicator(message: LoadingIndicatorMessages.loadingEventDetails)
        
        var request = EventDetailRequest()
        request.serial = AppEngine.sharedInstance.userID
        request.slug = slug
        let eventsApi = EventsApi()
        eventsApi.setCompletionHandler{ response, error in
            self.eventDetailsDelegate?.hideProgressIndicator()
            if error == nil{
                if let eventDetails = self.decodeFromJson(response!, modelType: EventDetails.self){
                    var sections = [EventsInteractor.EventDetailsSections]()
                    sections.append(.basic)
                    
                    if eventDetails.trainingData?.count ?? 0 > 0{
                        sections.append(.trainings)
                    }
                    if eventDetails.rentalData?.count ?? 0 > 0{
                        sections.append(.rentals)
                    }
                    if eventDetails.productInfo?.isEmpty ?? true == false{
                        sections.append(.about)
                    }
                    
                self.eventDetailsDelegate?.didFetchEventDetails(eventDetails, sections: sections)
                }
            }else{
                Log.i("Api Error - \(String(describing: error?.errorMessage)) ")
                self.eventDetailsDelegate?.showEmptyPageError(message: error!.errorMessage)
            }
        }
        
        if isMotoEvent{
            eventsApi.fetchMotoEventDetails(request)
        }else{
            eventsApi.fetchEvolveEventDetails(request)
        }
        
    }
}
