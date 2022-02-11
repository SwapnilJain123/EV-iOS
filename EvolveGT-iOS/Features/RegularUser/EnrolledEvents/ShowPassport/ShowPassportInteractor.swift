//
//  ShowPassportInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 26/01/22.
//  Copyright © 2022 YaraTech. All rights reserved.
//

import Foundation
protocol PassportViewDelegate {
    func onPassportFetched(_ passportInfo: PassportInfo)
}

class ShowPassportInteractor: BaseInteractor {
    
    var passportDelegate : PassportViewDelegate? = nil
    func fetchPassportInfo(){
        delegate?.showProgressIndicator(message: "")
        let api = ProfileApi()
        api.setCompletionHandler{data,error in
            self.delegate?.hideProgressIndicator()
            if error == nil{
               
                if let response = self.decodeFromJson(data!, modelType: ViewPassportResponse.self){
                    
                    if let passportInfo = response.data{
                        self.passportDelegate?.onPassportFetched(passportInfo)
                    }else{
                        self.delegate?.showEmptyPageError(message: response.msg ?? ErrorMessages.genericError)
                    }
                }else{
                     self.delegate?.showEmptyPageError(message: ErrorMessages.genericError)
                }
            }else{
                let apiError = error?.errorMessage ?? ErrorMessages.genericError
                
                 self.delegate?.showEmptyPageError(message: apiError)
            }
        }
        
        api.viewPassport(passportId: AppEngine.sharedInstance.passportId)
    }
}
