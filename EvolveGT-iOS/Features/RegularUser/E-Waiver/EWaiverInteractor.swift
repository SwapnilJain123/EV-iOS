//
//  EWaiverInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 04/09/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
protocol WaiverListDelegate {
    func waiverListFetched(waiverEvents:[EWaiver])
}

protocol WaiverDetailsDelegate {
    func fetchedWaiverDetails(eventData:EventData , userData:UserData? ,stateList : [State]?)
}
class EWaiverInteractor: BaseInteractor {
    
    var waiverDelegate:WaiverListDelegate?
    var waiverDetailsDelegate:WaiverDetailsDelegate?
    
    
    func getEWaiverList(){
        delegate?.showProgressIndicator(message: LoadingIndicatorMessages.loadingWaiverEvents)
        let api = WaiverApi()
        api.setCompletionHandler{data,error in
            self.delegate?.hideProgressIndicator()
            if error == nil{
               
                if let response = self.decodeFromJson(data!, modelType: WaiverListResponse.self){
                    
                    if response.result?.count ?? 0 > 0{
                       self.waiverDelegate?.waiverListFetched(waiverEvents: (response.result)!)
                    }else{
                        self.delegate?.showEmptyPageError(message: ErrorMessages.genericError)
                    }
                }else{
                     self.delegate?.showEmptyPageError(message: ErrorMessages.genericError)
                }
            }else{
                let apiError = error?.errorMessage ?? ErrorMessages.genericError
                
                 self.delegate?.showEmptyPageError(message: apiError)
            }
        }
        
        api.fetchWaiverList()
    }
    
    func getEWaiverDetails(eventId: Int){
        delegate?.showProgressIndicator(message: LoadingIndicatorMessages.loadingWaiverDetails)
        let api = WaiverApi()
        api.setCompletionHandler{data , error in
           self.delegate?.hideProgressIndicator()
            
            if error == nil{
                
                if let response = self.decodeFromJson(data!, modelType: WaiverDeatailsResponse.self){
                    
                    if response.eventData != nil{
                        self.waiverDetailsDelegate?.fetchedWaiverDetails(eventData: response.eventData!, userData: response.userData, stateList: response.states)
                        
                    }else{
                        self.delegate?.showEmptyPageError(message: ErrorMessages.emptyWaiverEventDetails)
                        
                    }
                    
                }else{
                    self.delegate?.showEmptyPageError(message: ErrorMessages.genericError)
                }
                
            }else{
                let message = error?.errorMessage ?? ErrorMessages.signatureUploadError

                self.delegate?.showEmptyPageError(message: message)
                
            }
        }
        var request = WaiverDetailsRequest()
        request.eventID = eventId
        request.userID = AppEngine.sharedInstance.userID
        
        api.fetchWaiverDetails(waiverDetailsRequest: request)
        
    }
    
    func saveSignature(userID: Int? ,eventID: Int? ,nameAndLocation:String? ,license:String? ,issuingState:String?,signature: String? , agree: Bool? ){
        
        delegate?.showProgressIndicator(message: LoadingIndicatorMessages.savingSignature)
        let api = WaiverApi()
        api.setCompletionHandler{data , error in
            
            self.delegate?.hideProgressIndicator()
            if error == nil{
                self.delegate?.showAlert(title: "Saved Signature", message: SuccessMessages.signatureSaved)
            }else{
                
                let message = error?.errorMessage ?? ErrorMessages.signatureUploadError
                self.delegate?.showAlert(title: "Error!", message: message)
            }
        }
        var request = SaveWaiverDetailsRequest()
        request.eventID = eventID
        request.userID = AppEngine.sharedInstance.userID
        request.agree = true
        request.license = license
        request.issuingState = issuingState
        request.nameAndLocation = nameAndLocation
        request.signature = signature
        api.saveWaiverDetails(saveWaiverDetailsRequest: request)
    }
    
}
