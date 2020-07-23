//
//  AdminApi.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class AdminApi: BaseApiAdapter{
    
    func fetchCompletedEvents(){
        let url: String  = "\(ApiConstants.BASE_URL)\(AdminApiConstants.COMPLETED_EVENTS)"
        setUrl(url: url)
        
        let completedEventRequest = CompletedEventRequest(isMotoevent:  AppEngine.sharedInstance.isEvApp() ? 0 : 1, userID: AppEngine.sharedInstance.currentUser!.id)
        setParameters(parameters: makeDictionary(completedEventRequest))
        
        super.makeRequest(method: .POST)
    }
    func fetchEventParticipants(eventID: String){
        let url: String  = "\(ApiConstants.BASE_URL)\(AdminApiConstants.EVENT_PARTICIPANTS)"
        setUrl(url: url)
        
        let eventParticipantRequest = EventParticipantRequest(eventID: eventID)
        setParameters(parameters: makeDictionary(eventParticipantRequest))
        
        super.makeRequest(method: .POST)
    }
    
    func upgradeSkill(skill: String, userID: String){
        let url: String  = "\(ApiConstants.BASE_URL)\(AdminApiConstants.UPDATE_SKILL_LEVEL)"
        setUrl(url: url)
        
        let skillUpgradeRequest = UpgradeSkillRequest(userID: userID, skilllevel: skill)
        setParameters(parameters: makeDictionary(skillUpgradeRequest))
        
        super.makeRequest(method: .POST)
    }
    
    func getSignature(signatureId: String){
        let url: String  = "\(ApiConstants.BASE_URL)\(AdminApiConstants.GET_SIGNATURE)"
        setUrl(url: url)
        let signatueRequest = SignatureRequest(signatureID: signatureId)
        setParameters(parameters: makeDictionary(signatueRequest))
        super.makeRequest(method: .POST)
    }
    
    func uploadSignature(signatureId: String, signature: Data){
        let url: String  = "\(ApiConstants.BASE_URL)\(AdminApiConstants.UPDATE_SIGNATURE)"
        setUrl(url: url)
        var encodedSignature = signature.base64EncodedString()
        encodedSignature = "\(AppConstants.ImageTag)\(encodedSignature)"
        let signatueRequest = SignatureUpdateRequest(signatureID: signatureId, signature: encodedSignature)
        setParameters(parameters: makeDictionary(signatueRequest))
        super.makeRequest(method: .POST)
    }
    
    func getCoachDuties(userId: String){
        let url: String  = "\(ApiConstants.BASE_URL)\(AdminApiConstants.COACH_DUTIES)"
        setUrl(url: url)
        let request = CoachDutyRequest(userId: userId)
        setParameters(parameters: makeDictionary(request))
        super.makeRequest(method: .POST)
    }
}
