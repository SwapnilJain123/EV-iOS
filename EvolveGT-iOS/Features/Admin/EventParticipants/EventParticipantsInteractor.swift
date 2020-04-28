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
    
    func filteredParticipants(participants : [EventParticipant], query: String)
}
class EventParticipantIntercator : BaseInteractor{
    
    var delegate: EventParticipantsViewDelegate?
    var participants = [EventParticipant]()
    
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
                        self.participants = eventParticipantsResponse.eventParticipants
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
    
    
    func filter(_ query: String){
        if query.isEmpty{
            self.delegate?.didFetchParticipants(participants:  participants)
        }else{
            let filteredList = self.participants.filter { ($0.displayName?.lowercased().contains(query.lowercased()) ?? false)}
            self.delegate?.filteredParticipants(participants: filteredList, query: query)
        }
    }
    
    func upgradeSkill(skill: String, userID: String){
        delegate?.showProgressIndicator(message: "")
        let adminApi  = AdminApi()
        adminApi.setCompletionHandler{ response, error in
            self.delegate?.hideProgressIndicator()
            self.delegate?.showSuccessMessage(message: SuccessMessages.skillUpgraded)
        }
        adminApi.upgradeSkill(skill: skill, userID: userID)
        
    }
}
