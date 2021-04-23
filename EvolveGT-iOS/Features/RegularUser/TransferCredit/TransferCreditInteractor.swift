//
//  TransferCreditInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 20/04/21.
//  Copyright © 2021 YaraTech. All rights reserved.
//

import Foundation
protocol TransferCreditDelegate {
    func transferredCredit()
}
class TransferCreditInteractor: BaseInteractor {
    var transferCreditDelegate:TransferCreditDelegate?
    
    func transferCredit(transferCreditRequest:TransferAmountRequest){
        delegate?.showProgressIndicator(message: "")
        let api = ProfileApi()
        api.setCompletionHandler{ data , error in
            self.delegate?.hideProgressIndicator()
            if error == nil{
                self.transferCreditDelegate?.transferredCredit()
            }else{
                self.delegate?.showErrorToastMessage(message: error?.errorMessage ?? ErrorMessages.genericError)
            }
            
        }
        
        api.transferCredit(transferCreditRequest: transferCreditRequest)
    }
}
