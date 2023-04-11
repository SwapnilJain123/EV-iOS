//
//  UploadPassportInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 26/01/22.
//  Copyright © 2022 YaraTech. All rights reserved.
//

import Foundation


class UploadPassportInteractor: BaseInteractor{
    var passportUploaded : (()->Void)? = nil
    func savePassport(selfie: Data, signature: Data ){
        
        delegate?.showProgressIndicator(message: "")
        let imageUploadItem = UploadItem(data: selfie, name: "myFile", fileName: "image.jpeg", mimeType: "image/jpeg")
        let api = ProfileApi()
        api.setCompletionHandler{data,error in
            self.delegate?.hideProgressIndicator()
            if error == nil{
                Log.i("Uploading Passport Success - ")
                self.passportUploaded?()
                
            }else{
                Log.i("Api Error - \(String(describing: error?.errorMessage)) ")
                self.delegate?.showErrorToastMessage(message: error?.errorMessage ?? ErrorMessages.genericError)
            }
        }
        
        api.uploadPassport(userId: AppEngine.sharedInstance.userID, imageUploadItem: imageUploadItem, signature: signature, eventId: AppEngine.sharedInstance.eventId)
    }
}
