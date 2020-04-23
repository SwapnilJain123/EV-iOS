//
//  EventParticipantsInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 23/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation

protocol EventParticipantsViewDelegate : BaseViewDelegate {
    func didFetchParticipants(participants : [EventParticipant])
}
class EventParticipantIntercator : BaseInteractor{
    
    var delegate: EventParticipantsViewDelegate?
    
    func getEventParticipants(_ eventId: String){
        delegate?.showProgressIndicator(message: "")
        let adminApi  = AdminApi()
       adminApi.setCompletionHandler{ response, error in
            self.delegate?.hideProgressIndicator()
            if error == nil{
                Log.i("Event Paticipants Request Success - ")
                if let eventParticipantsResponse = self.decodeFromJson(response!, modelType: EventParticpantResponse.self){
                    
                    if eventParticipantsResponse.eventParticipants.count == 0{
                        self.delegate?.showError(message: ErrorMessages.emptyEventParticipants)
                    }else{
                        self.delegate?.didFetchParticipants(participants:  eventParticipantsResponse.eventParticipants)
                    }
                   
                }
            }else{
                Log.i("Api Error - \(String(describing: error?.errorMessage)) ")
                self.delegate?.showError(message: error!.errorMessage)
            }
        }
        adminApi.fetchEventParticipants(eventID: eventId)
    }
}
