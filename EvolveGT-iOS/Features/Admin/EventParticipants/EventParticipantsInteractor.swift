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
    
    var adminViewDelegate: EventParticipantsViewDelegate?
    var participants = [EventParticipant]()
    var eventId = ""
    
    func getEventParticipants(_ eventId: String){
        super.delegate = adminViewDelegate
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
                        AppEngine.sharedInstance.generalSkills = eventParticipantsResponse.generalSkills
                        self.participants = eventParticipantsResponse.eventParticipants.sorted(by:
                            {
                                if let displayName = $0.displayName{
                                    return displayName < $1.displayName ?? ""
                                }
                                return false
                        })
                        self.adminViewDelegate?.didFetchParticipants(participants:  self.participants)
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
        if query.isEmpty(){
            self.adminViewDelegate?.didFetchParticipants(participants:  participants)
        }else{
            let filteredList = self.participants.filter { ($0.displayName?.lowercased().contains(query.lowercased()) ?? false)}
            self.adminViewDelegate?.filteredParticipants(participants: filteredList, query: query)
        }
    }
    
    func upgradeSkill(skill: String, userID: String){
        delegate?.showProgressIndicator(message: LoadingIndicatorMessages.upgradingSkill)
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
    
    func getAvailableFilterOptions() -> [String]{
        var options = [String]()
        let isEvApp = AppEngine.sharedInstance.isEvApp()
        for participant in participants where participant.skillLevel?.isNotEmpty ?? false{
            options.append("By Skill Level")
            break
        }
        
        if(isEvApp){
            for participant in participants where participant.trainings?.count ?? 0 > 0{
                options.append("By Training")
                break
            }
        }
        
        if(isEvApp){
            for participant in participants where participant.rentals?.count ?? 0 > 0{
                options.append("By Rentals")
                break
            }
        }
        for participant in participants where participant.motoClasses?.count ?? 0 > 0{
            options.append("By Classes")
            break
        }
        
        if(isEvApp){
            for participant in participants {
                if participant.eWaiver ?? false == false{
                    options.append("By Not Signed In")
                    break
                }
            }
        }
        
        if(isEvApp){
            for participant in participants {
                if participant.motoPurchased ?? false == true{
                    options.append("By Racers")
                    break
                }
            }
        }
        
        
        return options
    }
    
    func getAvailableSkillLevels() ->[String]{
        let skillLevels = participants.compactMap { $0.skillLevel }.unique().sorted(by: <)
        return skillLevels
    }
    
    func filterBySkillLevel(skill : String){
        let newList = participants.filter({$0.skillLevel == skill})
        adminViewDelegate?.didFetchParticipants(participants: newList)
    }
    
    func getAvailableMotoClasses() ->[String]{
        var motoClasses = [String]()
        for participnt in participants where participnt.motoClasses?.count ?? 0 > 0{
            for motoclass in participnt.motoClasses! where motoclass.raceClasses?.count ?? 0 > 0{
                for race in motoclass.raceClasses! where race.className?.isEmpty ?? true == false {
                    motoClasses.append(race.className!)
                }
            }
        }
        return motoClasses.unique().sorted(by: <)
    }
    func filterByMotoClasses(motoClass : String){
        
         var newList = [EventParticipant]()
        for participnt in participants where participnt.motoClasses?.count ?? 0 > 0{
            for motoclass in participnt.motoClasses! where motoclass.raceClasses?.count ?? 0 > 0{
                for race in motoclass.raceClasses! where race.className == motoClass {
                    newList.append(participnt)
                }
            }
        }
        adminViewDelegate?.didFetchParticipants(participants: newList)
    }
    
    func filterByUsersNotSignedIn(){
        var newList = [EventParticipant]()
        for participnt in participants where participnt.eWaiver ?? false == false{
            newList.append(participnt)
        }
        adminViewDelegate?.didFetchParticipants(participants: newList)
    }
    
    func filterByRacers(){
        var newList = [EventParticipant]()
        for participnt in participants where participnt.motoPurchased ?? false == true{
            newList.append(participnt)
        }
        adminViewDelegate?.didFetchParticipants(participants: newList)
    }
    func getAvailableTrainings() ->[String]{
        var trainings = [String]()
        for participnt in participants where participnt.trainings?.count ?? 0 > 0{
            trainings.append(contentsOf: participnt.trainings!)
        }
        return trainings.unique().sorted(by: <)
    }
    func filterByTraining(training : String){
        let newList = participants.filter({$0.trainings?.contains(training) ?? false})
        adminViewDelegate?.didFetchParticipants(participants: newList)
    }
    func clearFilter(){
        adminViewDelegate?.didFetchParticipants(participants: participants)
    }
    func getAvailableRentals() ->[String]{
        var rentals = [String]()
        for participnt in participants where participnt.rentals?.count ?? 0 > 0{
            rentals.append(contentsOf: participnt.rentals!.compactMap({ $0.name }))
        }
        return rentals.unique().sorted(by: <)
    }
    func filterByRentals(selectedRental : String){
        var newList = [EventParticipant]()
        for participant in participants where participant.rentals?.count ?? 0 > 0{
            for rental in participant.rentals! where rental.name == selectedRental{
                newList.append(participant)
                break
            }
        }
        adminViewDelegate?.didFetchParticipants(participants: newList)
    }
}
