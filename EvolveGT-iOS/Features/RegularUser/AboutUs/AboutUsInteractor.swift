//
//  AboutUsInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 15/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
protocol AboutUsInteractorDelegate:BaseViewDelegate {
    func getAppVersionUpdateMessage(message:String)
}
class AboutUsInteractor:BaseInteractor{
    
    var delegate: AboutUsInteractorDelegate?
    
    func checkAppVersionUpdate(){
        self.delegate?.showProgressIndicator(message: "")
        let genericApi = GenericApi()
        genericApi.setCompletionHandler{data,error in
            self.delegate?.hideProgressIndicator()
            if error == nil{
                
                if let appVersion = self.decodeFromJson(data! , modelType: AppVersion.self){
                    if appVersion.iosVersionCode ?? "1.0" > BuildScheme.getBuildVersion(){
                        self.delegate?.getAppVersionUpdateMessage(message: SuccessMessages.latestVersion)
                    }else{
                        self.delegate?.getAppVersionUpdateMessage(message: SuccessMessages.oldVersion)
                    }
                }else{
                    self.delegate?.getAppVersionUpdateMessage(message: "")
                }
                
            }else{
                self.delegate?.getAppVersionUpdateMessage(message: "")
            }
        }
        genericApi.checkForAppUpdate()
    }
    
}
