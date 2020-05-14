//
//  CompletedEventsInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import  AFDateHelper
protocol CompletedEventsViewDelegate : BaseViewDelegate{
    
    func didFetchCompletedEvents(events : [CompletedEvent])
    
    func presentTrainingFilterOptions(options : [String])
    
    func presentEventTypeFilterOptions(options : [String])
    
    func presentMonthFilterOptions(options : [String])
    
}

class CompletedEventsInteractor : BaseInteractor{
    
    
    
    var delegate: CompletedEventsViewDelegate?
    var completedEvents = [CompletedEvent]()
    
    override func viewDidLoad() {
        fetchCompletedEvents()
    }
    
    func fetchCompletedEvents() {
        delegate?.showProgressIndicator(message: LoadingIndicatorMessages.loadingCompletedEvents)
        let adminApi = AdminApi()
        adminApi.setCompletionHandler{ response, error in
            self.delegate?.hideProgressIndicator()
            if error == nil{
                Log.i("Completed Event Success - ")
                if let completedeventResponse = self.decodeFromJson(response!, modelType: CompletedEventsResponse.self){
                    
                    if completedeventResponse.completedEvents.count == 0{
                        self.delegate?.showEmptyPageError(message: ErrorMessages.emptyCompletedEvents)
                    }else{
                        self.completedEvents.removeAll()
                        self.completedEvents.append(contentsOf: completedeventResponse.completedEvents)
                        self.delegate?.didFetchCompletedEvents(events: completedeventResponse.completedEvents)
                    }
                    
                }
            }else{
                Log.i("Api Error - \(String(describing: error?.errorMessage)) ")
                self.delegate?.showEmptyPageError(message: error!.errorMessage)
            }
        }
        adminApi.fetchCompletedEvents()
    }
    
    
    func search(query: String) {
        
        if query.isEmpty{
            self.delegate?.didFetchCompletedEvents(events: completedEvents)
        }else{
            let filteredEvents =  completedEvents.filter{
                $0.title.lowercased().starts(with: query.lowercased())
            }
            self.delegate?.didFetchCompletedEvents(events: filteredEvents)
        }
    }
    
    func filterBy(_ query:String, _ filterType: FilterType){
        if query.isEmpty && filterType != .none{
            return
        }
        
        var filteredList = [CompletedEvent]()
        switch filterType {
        case .eventType:
            filteredList = self.completedEvents.filter {
                $0.eventType.lowercased() == query.lowercased()
                
            }
        case .month:
            filteredList = self.completedEvents.filter { $0.eventDate.formattedDate(outputFormat: .FORMAT_MMM_YYYY).lowercased() == query.lowercased()
            }
        case .trainingType:
            filteredList = self.completedEvents.filter { ($0.trainingType?.contains(query) ?? false)
            }
        case .none:
            filteredList = self.completedEvents.filter { _ in true
            }
        }
        self.delegate?.didFetchCompletedEvents(events: filteredList)
        
    }
    func filterItems(with filterType: FilterType) {
        switch filterType {
        case .trainingType:
            Log.d("Filter By Training")
            //get unique trinings from the completed event list
            let trainingsArray = completedEvents.compactMap { $0.trainingType }
            let trainings = Array(Set(trainingsArray.flatMap { $0 })).sorted(by: <)
            self.delegate?.presentTrainingFilterOptions(options: trainings)
        case .month:
            Log.d("Filter By Month")
            
            let sortedEvents = completedEvents.sorted(by: { $0.eventDate < $1.eventDate })
            var eventMonths = sortedEvents.compactMap { $0.eventDate }.map{
                $0.formattedDate(outputFormat: .FORMAT_YYYY_MM)
            }.unique().sorted(by: <)
            eventMonths = eventMonths.map{
                let dateString = "\($0) 15"
                 return dateString.formattedDate(outputFormat: .FORMAT_MMM_YYYY)
            }
            self.delegate?.presentMonthFilterOptions(options: eventMonths)
        case .eventType:
            Log.d("Filter By Event")
            let eventTypes = completedEvents.compactMap { $0.eventType }.unique().sorted(by: <)
            self.delegate?.presentEventTypeFilterOptions(options: eventTypes)
        case .none:
            Log.d("Filter Clear")
            self.delegate?.didFetchCompletedEvents(events: completedEvents)
        }
    }
}
