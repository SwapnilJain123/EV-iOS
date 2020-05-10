//
//  CreditHistoryInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 09/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation

protocol CreditHistoryViewDelegate : BaseViewDelegate{

    func didFetchCreditHistory(creditHistory : [CreditHistory])
}

class CreditHistoryInteractor : BaseInteractor{
    var delegate : CreditHistoryViewDelegate?
    
    
    func fetchCreditHistory() {
        delegate?.showProgressIndicator(message: LoadingIndicatorMessages.loadingCreditHistory)
        let profileApi = ProfileApi()
        profileApi.setCompletionHandler{ response, error in
            self.delegate?.hideProgressIndicator()
            if error == nil{
                Log.i("User Credit History fetched Success - ")
                if let creditResponse = self.decodeFromJson(response!, modelType: CreditHistoryResponse.self){
                    
                    if creditResponse.creditHistoryList == nil{
                        self.delegate?.showEmptyPageError(message: ErrorMessages.emptyCreditList)
                    }else{
                        self.delegate?.didFetchCreditHistory(creditHistory: creditResponse.creditHistoryList!)
                    }
                    
                }
            }else{
                Log.i("Api Error - \(String(describing: error?.errorMessage)) ")
                self.delegate?.showEmptyPageError(message: error!.errorMessage)
            }
        }
        profileApi.fetchCreditHistory(userId: AppEngine.sharedInstance.userID)
    }
}
