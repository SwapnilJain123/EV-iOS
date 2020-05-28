//
//  ArchieCardInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 26/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
protocol ArchieCardListDelegate {
    func didFetchArchieCardList(archieCardList:[ArchieCard])
}
protocol ArchieCardDetailsDelegate {
    func didFetchArchieCardDetails(archieCardDetails:ArchieCardDetails)
}
class ArchieCardInteractor:BaseInteractor{
    var viewDelegate : BaseViewDelegate?
    var archieCardListDelegate: ArchieCardListDelegate?
     var archieCardDetailsDelegate: ArchieCardDetailsDelegate?
    func getArchieCards(){
        
        self.viewDelegate?.showProgressIndicator(message: LoadingIndicatorMessages.loadingArchieCardList)
        
        let archieCardApi = ArchieCardApi()
        archieCardApi.setCompletionHandler(){data , error in
            
            self.viewDelegate?.hideProgressIndicator()
            
            if error == nil{
                if let archieCardListResponse = self.decodeFromJson(data!, modelType: ArchiCardListResponse.self){
                    if archieCardListResponse.archieCardList?.count  ?? 0 == 0{
                        self.viewDelegate?.showEmptyPageError(message: ErrorMessages.genericError)
                    }else{
                        self.archieCardListDelegate?.didFetchArchieCardList(archieCardList: archieCardListResponse.archieCardList!)
                    }
                }else{
                    self.viewDelegate?.showEmptyPageError(message: ErrorMessages.genericError)
                }
            }else{
                self.viewDelegate?.showEmptyPageError(message: error?.errorMessage ?? ErrorMessages.genericError)
            }
        }
        archieCardApi.fetchArchieCardList()
    }
    
    func getArchieCardDetails(slug:String){
        
         self.viewDelegate?.showProgressIndicator(message: LoadingIndicatorMessages.loadingArchieCardList)
        let archieCardApi = ArchieCardApi()
        archieCardApi.setCompletionHandler{data , error in
            if error == nil{
                
                self.viewDelegate?.hideProgressIndicator()
                self.viewDelegate?.hideEmptyPageError()
                
                let archieCardDetailsResponse = self.decodeFromJson(data!, modelType:ArchieCardDetailsResponse.self)
                self.archieCardDetailsDelegate?.didFetchArchieCardDetails(archieCardDetails: (archieCardDetailsResponse?.archieCards)!)
                
            }else{
                self.viewDelegate?.showEmptyPageError(message: error?.errorMessage ?? ErrorMessages.genericError)
            }
            
        }
        archieCardApi.fetchArchieCardDetails(slug: slug)
        
        
    }
    
    
}






