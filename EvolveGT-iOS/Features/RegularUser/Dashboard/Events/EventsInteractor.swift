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
    func addEventToCalendar(event: Event)
}

protocol EventDetailsDelegate : BaseViewDelegate{
    func didFetchEventDetails(_ eventDetails : EventDetails, sections :[EventsInteractor.EventDetailsSections] )
    func validationError(_ errorMessage: String)
     func addEventToCalendar(event: EventDetails)
    
    func registrationDenied(title: String, message: String)
    func mrlLicenceRequired(eventDetails: EventDetails)
}
class EventsInteractor :BaseInteractor{
    
    var slug = ""
    var isMotoEvent = false
    
    enum EventDetailsSections: Int{
        case basic
        case rentals
        case trainings
        case about
        case eventClasses
        case transponder
        case skillSelection
        case trackDays
        case mrlLicence
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
            
             let eventMonths = events.compactMap { $0.eventMonthYear }.unique()
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
                self.syncCartBadgeCount()
                self.eventListDelegate?.addEventToCalendar(event: event)
            }else{
                Log.i("Api Error - \(String(describing: error?.errorMessage)) ")
                self.eventListDelegate?.showErrorToastMessage(message: error!.errorMessage)
                self.eventDetailsDelegate?.showErrorToastMessage(message: error!.errorMessage)
            }
        }
        cartApi.addEvolveEventToCart(eventRequest: request)
    }
    
    func addTrackDayToCart(_ event: Event){
        super.delegate = eventDetailsDelegate
        
        eventDetailsDelegate?.showProgressIndicator(message: LoadingIndicatorMessages.addingEventToCart)
        
        
        var request = TrackDayCartRequest()
        request.eventId = event.eventID
        request.userID = AppEngine.sharedInstance.userID
        
        
        let cartApi = CartApi()
        cartApi.setCompletionHandler{ response, error in
            self.eventDetailsDelegate?.hideProgressIndicator()
            if error == nil{
                self.syncCartBadgeCount()
                self.fetchEventDetails(slug: self.slug, isMotoEvent: self.isMotoEvent)
            }else{
                Log.i("Api Error - \(String(describing: error?.errorMessage)) ")
                self.eventDetailsDelegate?.showErrorToastMessage(message: error!.errorMessage)
            }
        }
        cartApi.addTrackDayToCart(eventRequest: request)
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
                
                 self.eventDetailsDelegate?.addEventToCalendar(event: event)
                self.syncCartBadgeCount()
            }else{
                Log.i("Api Error - \(String(describing: error?.errorMessage)) ")
                self.eventDetailsDelegate?.showErrorToastMessage(message: error!.errorMessage)
            }
        }
        cartApi.addEvolveEventToCart(eventRequest: request)
    }
    
    func addMotoEventToCart(_ event: EventDetails) {
        super.delegate = eventDetailsDelegate
        
        var hasValidClasses = true
        for eventClass in eventDetails.eventClasses!{
            hasValidClasses = hasValidClasses && eventClass.validateRaceClasses()
        }
        
        if hasValidClasses == false{
            self.eventDetailsDelegate?.validationError(ErrorMessages.invalidBikeData)
            self.eventDetailsDelegate?.didFetchEventDetails(eventDetails, sections: [EventDetailsSections]())
            return
        }else if event.racerStatus?.isEmpty() ?? true{
            self.eventDetailsDelegate?.validationError(ErrorMessages.skillNotSelected)
            return
        }else if event.transponderNo?.isEmpty ?? true{
            
            self.eventDetailsDelegate?.validationError( "Please provide your transponder number.")
            return
        }else if event.bikeNo?.isEmpty ?? true{
            
            self.eventDetailsDelegate?.validationError( "Please provide your bike number.")
            return
        }else if !(event.trackValidation ?? false){
            
            self.eventDetailsDelegate?.showAlert(title: "Track Day Required", message: "Please purchase track day before proceeding with event registration.")
            return
        }else if event.mrlValidation ?? false == false{
            
            self.eventDetailsDelegate?.validationError("MRL Licence required.")
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
        
        request.skill = event.racerStatus;
        request.eventClasses = event.selectedEventClasses
        request.eventClassTotal = event.selectedEventClassTotal
        request.transponderNo = event.transponderNo
        request.bikeNumber = event.bikeNo
        
        let cartApi = CartApi()
        cartApi.setCompletionHandler{ response, error in
            self.eventDetailsDelegate?.hideProgressIndicator()
            if error == nil{
               
                 self.eventDetailsDelegate?.addEventToCalendar(event: event)
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
    
    var eventDetails = EventDetails()
    func fetchEventDetails(slug: String, isMotoEvent: Bool = false){
        self.slug = slug
        self.isMotoEvent = isMotoEvent
        
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
                    
                    self.eventDetails = eventDetails
                    var sections = [EventsInteractor.EventDetailsSections]()
                    sections.append(.basic)
                    
                    if let eventClasses = eventDetails.eventClasses{
                        for _ in eventClasses{
                            sections.append(.eventClasses)
                        }
                    }
                    
                    if eventDetails.trainingData?.count ?? 0 > 0{
                        sections.append(.trainings)
                    }
                    if eventDetails.rentalData?.count ?? 0 > 0{
                        sections.append(.rentals)
                    }
                    
                    eventDetails.registeredSkill = eventDetails.racerStatus ?? ""
                    
                    if(isMotoEvent){
                        sections.append(.skillSelection)
                        if eventDetails.trackDays?.count ?? 0 > 0{
                            sections.append(.trackDays)
                        }
                        sections.append(.transponder)
                        if (!(eventDetails.mrlValidation ?? false)) && (eventDetails.mrlAddToCart ?? false){
                            sections.append(.mrlLicence)
                        }
                    }
                    
                    
                    if eventDetails.productInfo?.isEmpty() ?? true == false{
                        sections.append(.about)
                    }
                    
                    self.eventDetailsDelegate?.didFetchEventDetails(eventDetails, sections: sections)
                    
                    
                    if eventDetails.registrationClosed ?? true{
                        self.eventDetailsDelegate?.registrationDenied(title: "Registration Closed", message: "Registration for this event has been closed.")
                    }else if !(eventDetails.skillEligible ?? false){
                        self.eventDetailsDelegate?.registrationDenied(title: "Skill Not Eligible", message: "GT1 and E1 are not eligible to participate in race.")
                    }else if (!(eventDetails.mrlValidation ?? false)) && (eventDetails.mrlAddToCart ?? false == false){
                        self.eventDetailsDelegate?.mrlLicenceRequired(eventDetails: eventDetails)
                    }
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
    
    func addMrlLicenceToCart(mrlData: MrlData){
        var request = AddMembershipToCartRequest()
        request.membership = mrlData.slug
        request.price = mrlData.price
        request.title = mrlData.title
        request.userId = AppEngine.sharedInstance.userID
        request.force = "\(mrlData.force)"
        self.eventDetailsDelegate?.showProgressIndicator(message: "Adding mrl licence to the cart")
        let cartApi = CartApi()
        cartApi.setCompletionHandler{data, error in
            self.eventDetailsDelegate?.hideProgressIndicator()
            if error == nil{
                self.eventDetailsDelegate?.showSuccessToastMessage(message: SuccessMessages.membershipAddedToCart)
                self.fetchEventDetails(slug: self.slug, isMotoEvent: self.isMotoEvent)
            }else{
                self.eventDetailsDelegate?.showErrorToastMessage(message: error?.errorMessage ?? ErrorMessages.genericError)
            }
        }
        cartApi.addMembershipToCart(request: request)
    }

}
