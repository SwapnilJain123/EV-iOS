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
    var eventId = ""
    
    func getEventParticipants(_ eventId: String){
        delegate?.showProgressIndicator(message: LoadingIndicatorMessages.loadingParticipants)
        let adminApi  = AdminApi()
        self.eventId = eventId
        
        adminApi.setCompletionHandler{ response, error in
            self.delegate?.hideProgressIndicator()
            if error == nil{
                Log.i("Event Paticipants Request Success - ")
                self.delegate?.hideEmptyPageError()
                if let eventParticipantsResponse = self.decodeFromJson(response!, modelType: EventParticpantResponse.self){
                    
                    if eventParticipantsResponse.eventParticipants.count == 0{
                        self.delegate?.showEmptyPageError(message: ErrorMessages.emptyEventParticipants)
                    }else{
                        self.participants = eventParticipantsResponse.eventParticipants.sorted(by:
                            {
                                if let displayName = $0.displayName{
                                    return displayName < $1.displayName ?? ""
                                }
                                return false
                            })
                        self.delegate?.didFetchParticipants(participants:  self.participants)
                    }
                    
                }
            }else{
                Log.i("Api Error - \(String(describing: error?.errorMessage)) ")
                self.delegate?.showEmptyPageError(message: error!.errorMessage)
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
            if error == nil{
                self.delegate?.hideProgressIndicator()
                self.delegate?.showSuccessToastMessage(message: SuccessMessages.skillUpgraded)
                self.getEventParticipants(self.eventId)
            }else{
                self.delegate?.showAlert(title: "Error", message: error?.errorMessage ?? ErrorMessages.genericError)
            }
        }
        adminApi.upgradeSkill(skill: skill, userID: userID)
    }
    
    
    func onAccessoriesClicked(participant : EventParticipant){
        
    }
}
