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
    func validationError(_ errorMessage: String)
}
class EventsInteractor :BaseInteractor{
    
    enum EventDetailsSections: Int{
        case basic
        case rentals
        case trainings
        case about
        case eventClasses
        case transponder
        case skillSelection
        case trackDays
    }
    enum MotoSections: Int{
        case eventClasses
        case transponder
        case skillSelection
        case trackDays
    }
    var eventListDelegate : EventListViewDelegate?
    var eventDetailsDelegate : EventDetailsDelegate?
    var events = [Event]()
    func fetchEventList(){
        
        if self.events.count > 0{
            return
        }
        
        eventListDelegate?.showProgressIndicator(message: LoadingIndicatorMessages.loadingEvents)
        let eventsApi  = EventsApi()
        
        
        eventsApi.setCompletionHandler{ response, error in
            self.eventListDelegate?.hideProgressIndicator()
            self.eventListDelegate?.hideEmptyPageError()
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
            
             let eventMonths = events.compactMap { $0.eventMonthYear }.unique().sorted(by: <)
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
        if query.isEmpty() && filterType != .none{
            return
        }
        
        var filteredList = [Event]()
        switch filterType {
        case .eventType:
            filteredList = self.events.filter {
                $0.eventType?.lowercased() == query.lowercased()
                
            }
        case .month:
            filteredList = self.events.filter { $0.eventMonthYear.lowercased() == query.lowercased()
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
        super.delegate = eventListDelegate
        if event.isMotoEvent{
            //Ignore adding moto events here
            return
        }
        
        eventListDelegate?.showProgressIndicator(message: LoadingIndicatorMessages.addingEventToCart)
        
        eventDetailsDelegate?.showProgressIndicator(message: LoadingIndicatorMessages.addingEventToCart)
        
        var request = EventCartRequest()
        request.eventSlug = event.slug
        request.eventDate = event.eventDate
        request.eventSlug = event.slug
        request.eventPrice = event.price
        request.serial = AppEngine.sharedInstance.userID
        request.role = AppEngine.sharedInstance.userRole
        request.title = event.title
        request.eventCouponCode = event.couponCode
        
        let cartApi = CartApi()
        cartApi.setCompletionHandler{ response, error in
            self.eventListDelegate?.hideProgressIndicator()
            self.eventDetailsDelegate?.hideProgressIndicator()
            if error == nil{
                self.eventListDelegate?.showSuccessToastMessage(message: SuccessMessages.eventAddedToCart)
                self.eventDetailsDelegate?.showSuccessToastMessage(message: SuccessMessages.eventAddedToCart)
                self.syncCartBadgeCount()
            }else{
                Log.i("Api Error - \(String(describing: error?.errorMessage)) ")
                self.eventListDelegate?.showErrorToastMessage(message: error!.errorMessage)
                self.eventDetailsDelegate?.showErrorToastMessage(message: error!.errorMessage)
            }
        }
        cartApi.addEvolveEventToCart(eventRequest: request)
    }
    
    func addEvolveEventToCart(_ event: EventDetails){
         super.delegate = eventDetailsDelegate
        eventDetailsDelegate?.showProgressIndicator(message: LoadingIndicatorMessages.addingEventToCart)
        var request = EventCartRequest()
        request.eventSlug = event.slug
        request.eventDate = event.eventDate
        request.eventSlug = event.slug
        request.eventPrice = event.getRoleBasedPrice(role: AppEngine.sharedInstance.userRole)
        request.serial = AppEngine.sharedInstance.userID
        request.role = AppEngine.sharedInstance.userRole
        request.title = event.title
        request.eventCouponCode = event.couponCode
        
        if let rentals = event.rentalData{
            request.rentalList = [RentalRequest]()
            for rental in rentals where rental.selectedVariant != nil{
                var rentalRequest = RentalRequest()
                rentalRequest.price = rental.selectedVariant?.price
                rentalRequest.id = rental.productID
                rentalRequest.slug = rental.slug
                rentalRequest.price = rental.selectedVariant?.price
                rentalRequest.selectedSize = rental.selectedVariant?.attributeValue
                request.rentalList?.append(rentalRequest)
            }
        }
        
        if let trainings = event.trainingData{
            request.trainingList = [TrainingRequest]()
            for training in trainings where training.isSelected{
                var trainingRequest = TrainingRequest()
                trainingRequest.price = training.price
                trainingRequest.slug = training.slug
                trainingRequest.id = training.trainingID
                trainingRequest.trainingName = training.title
                request.trainingList?.append(trainingRequest)
            }
        }
        
        let cartApi = CartApi()
        cartApi.setCompletionHandler{ response, error in
            self.eventDetailsDelegate?.hideProgressIndicator()
            if error == nil{
                self.eventDetailsDelegate?.showSuccessToastMessage(message: SuccessMessages.eventAddedToCart)
                self.syncCartBadgeCount()
            }else{
                Log.i("Api Error - \(String(describing: error?.errorMessage)) ")
                self.eventDetailsDelegate?.showErrorToastMessage(message: error!.errorMessage)
            }
        }
        cartApi.addEvolveEventToCart(eventRequest: request)
    }
    
    func addMotoEventToCart(_ event: EventDetails){
        super.delegate = eventDetailsDelegate
        if event.selectedSkill.isEmpty(){
            self.eventDetailsDelegate?.validationError(ErrorMessages.skillNotSelected)
            return
        }else if event.selectedEventClasses.count == 0{
            self.eventDetailsDelegate?.validationError(ErrorMessages.emptyEventClass)
            return
        }else if ((event.transponder?.isSelected ?? false) == false && ((event.transponder?.number ?? "").isEmpty())){
            self.eventDetailsDelegate?.validationError(ErrorMessages.transponderNotSelected)
            return 
        }
        
        
        eventDetailsDelegate?.showProgressIndicator(message: LoadingIndicatorMessages.addingEventToCart)
        var request = EventCartRequest()
        request.eventSlug = event.slug
        request.eventDate = event.eventDate;
        request.eventSlug = event.slug;
        request.eventID = event.eventID
        request.eventPrice = event.getRoleBasedPrice(role: AppEngine.sharedInstance.userRole);
        request.serial = AppEngine.sharedInstance.userID
        request.role = AppEngine.sharedInstance.userRole
        request.title = event.title;
        
        request.skill = event.selectedSkill;
        request.eventClasses = event.selectedEventClasses
        request.eventClassTotal = event.selectedEventClassTotal
        request.transponderNo = event.transponder?.number
        request.transponderRented = event.transponder?.isSelected
        
        let cartApi = CartApi()
        cartApi.setCompletionHandler{ response, error in
            self.eventDetailsDelegate?.hideProgressIndicator()
            if error == nil{
                self.eventDetailsDelegate?.showSuccessToastMessage(message: SuccessMessages.eventAddedToCart)
                self.syncCartBadgeCount()
            }else{
                Log.i("Api Error - \(String(describing: error?.errorMessage)) ")
                self.eventDetailsDelegate?.showErrorToastMessage(message: error!.errorMessage)
            }
        }
        cartApi.addMotoEventToCart(eventRequest: request)
    }
    
    //Mark- Event Details
    
    func resetEventList(){
        self.events.removeAll()
    }
    func fetchEventDetails(slug: String, isMotoEvent: Bool = false){
        eventDetailsDelegate?.showProgressIndicator(message: LoadingIndicatorMessages.loadingEventDetails)
        
        var request = EventDetailRequest()
        request.serial = AppEngine.sharedInstance.userID
        request.slug = slug
        let eventsApi = EventsApi()
        eventsApi.setCompletionHandler{ response, error in
            self.eventDetailsDelegate?.hideProgressIndicator()
            self.eventDetailsDelegate?.hideEmptyPageError()
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
                    if eventDetails.activeEventClasses.count > 0{
                        sections.append(.eventClasses)
                    }
                    
                    if eventDetails.skillSet?.count ?? 0 > 0{
                        sections.append(.skillSelection)
                        
                        for skill in eventDetails.skillSet! where skill.active ?? false{
                            eventDetails.selectedSkill = skill.skill ?? ""
                        }
                        
                    }
                    if eventDetails.trackDays?.count ?? 0 > 0{
                        sections.append(.trackDays)
                    }
                    if eventDetails.transponder != nil{
                        sections.append(.transponder)
                        eventDetails.transponder!.isSelected = eventDetails.transponder!.inCart ?? false
                    }
                    if eventDetails.productInfo?.isEmpty() ?? true == false{
                        sections.append(.about)
                    }
                    
                    self.eventDetailsDelegate?.didFetchEventDetails(eventDetails, sections: sections)
                }else{
                    self.eventDetailsDelegate?.showEmptyPageError(message: ErrorMessages.genericError)
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
    
    func getMotoSections(_ eventDetails: EventDetails?) -> [MotoSections]{
        var sections = [MotoSections]()
        
        if eventDetails?.activeEventClasses.count ?? 0 > 0{
            sections.append(.eventClasses)
        }
        
        if eventDetails?.skillSet?.count ?? 0 > 0{
            sections.append(.skillSelection)
        }
        if eventDetails?.trackDays?.count ?? 0 > 0{
            sections.append(.trackDays)
        }
        if eventDetails?.transponder != nil{
            sections.append(.transponder)
        }
        return sections
    }
}
