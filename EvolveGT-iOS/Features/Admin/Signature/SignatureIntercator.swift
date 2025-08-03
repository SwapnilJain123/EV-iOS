//
//  SignatureIntercator.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 29/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation

protocol SignatureViewDelegate : BaseViewDelegate {
    func didFetchSignature(signature : Data)
    func didUpdateSignature()
    
}
class SignatureIntercator : BaseInteractor{
    var signatureViewDelegate: SignatureViewDelegate?
    
    func getSignature(signatureId: Int){
        super.delegate = signatureViewDelegate
        delegate?.showProgressIndicator(message: LoadingIndicatorMessages.loadingSignature)
        let adminApi  = AdminApi()
        
        
        adminApi.setCompletionHandler{ response, error in
            self.delegate?.hideProgressIndicator()
             self.delegate?.hideEmptyPageError()
            if error == nil{
                Log.i("Signature Request Success - ")
                
                if let signatureResponse = self.decodeFromJson(response!, modelType: SignatureResponse.self), var signature = signatureResponse.signature{
                    
                    signature = signature.replacingOccurrences(of: AppConstants.ImageTag, with: "")
                    signature = signature.replacingOccurrences(of: "\n", with: "")
                    guard let signatureData = Data(base64Encoded: signature) else {
                        self.delegate?.showEmptyPageError(message: ErrorMessages.genericError)
                        return }
                    self.signatureViewDelegate?.didFetchSignature(signature: signatureData)
                    
                }
            }else{
                Log.i("Api Error - \(String(describing: error?.errorMessage)) ")
                self.delegate?.showEmptyPageError(message: error!.errorMessage)
            }
        }
        adminApi.getSignature(signatureId: signatureId)
    }
    
    func saveSignature(signatureId: Int, signature: Data){
        super.delegate = signatureViewDelegate
        delegate?.showProgressIndicator(message: LoadingIndicatorMessages.uploadingSignature)
        let adminApi  = AdminApi()
        
        
        adminApi.setCompletionHandler{ response, error in
            self.delegate?.hideProgressIndicator()
             self.delegate?.hideEmptyPageError()
            if error == nil{
                Log.i("Signature Saving Success - ")
                self.signatureViewDelegate?.didUpdateSignature()
                
            }else{
                Log.i("Api Error - \(String(describing: error?.errorMessage)) ")
                self.delegate?.showEmptyPageError(message: error!.errorMessage)
            }
        }
        adminApi.uploadSignature(signatureId: signatureId, signature: signature)
    }
}

