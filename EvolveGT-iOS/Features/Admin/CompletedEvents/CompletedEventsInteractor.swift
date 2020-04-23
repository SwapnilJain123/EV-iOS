//
//  CompletedEventsInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
protocol CompletedEventsViewDelegate : BaseViewDelegate{
    
    func didFetchCompletedEvents(events : [CompletedEvent])
}

class CompletedEventsInteractor : BaseInteractor{
    
     var delegate: CompletedEventsViewDelegate?
    
    override func viewDidLoad() {
        fetchCompletedEvents()
    }
    
    func fetchCompletedEvents() {
        delegate?.showProgressIndicator(message: "")
        let adminApi = AdminApi()
        adminApi.setCompletionHandler{ response, error in
            self.delegate?.hideProgressIndicator()
            if error == nil{
                Log.i("Completed Event Success - ")
                if let completedeventResponse = self.decodeFromJson(response!, modelType: CompletedEventsResponse.self){
                    
                    if completedeventResponse.completedEvents.count == 0{
                        self.delegate?.showError(message: ErrorMessages.emptyCompletedEvents)
                    }else{
                        self.delegate?.didFetchCompletedEvents(events: completedeventResponse.completedEvents)
                    }
                   
                }
            }else{
                Log.i("Api Error - \(String(describing: error?.errorMessage)) ")
                self.delegate?.showError(message: error!.errorMessage)
            }
        }
        adminApi.fetchCompletedEvents()
    }
}
