//
//  SettingsInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 14/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
protocol SettingsDelegate{
    func populateSettingsItems(settings: [SettingsItem])
}
class SettingsInteractor: BaseInteractor{
    
    
    var viewDelegate: BaseViewDelegate?
    var settingsDelegate: SettingsDelegate?
    
    func getSettingsItems(){
        var menuItems = [SettingsItem]()
        menuItems.append(SettingsItem.languageSettings)
        menuItems.append(SettingsItem.moreActionsSettings)
        viewDelegate?.showProgressIndicator(message: LoadingIndicatorMessages.readingPrefernces)
        let api = ProfileApi()
        api.setCompletionHandler{ data, error in
            self.viewDelegate?.hideProgressIndicator()
            if error == nil{
                if let response = self.decodeFromJson(data!, modelType: NotificationTypesResponse.self){
                    if response.preferences?.count ?? 0 > 0{
                        let item = SettingsItem()
                        item.title = "Push Notifications"
                        item.settingsType = .notification
                        item.menuItems = response.preferences!
                        menuItems.insert(item, at: 1)
                    }
                }
            }
            self.settingsDelegate?.populateSettingsItems(settings: menuItems)
        }
        api.fetchNotificationPreferences(userId: AppEngine.sharedInstance.userID)
    }
    
    func updateNotificationRequest(preferences: [UserPreference]){
        
        var request = NotificationPreferenceUpdateRequest()
        request.userId = AppEngine.sharedInstance.userID
        request.preferences = [NotificationTypeUpdate]()
        for pref in preferences{
            var notificationPref = NotificationTypeUpdate()
            notificationPref.notificationId = pref.id
            notificationPref.notificationStatus = String(pref.status ?? 0)
            notificationPref.notificationType = pref.title
            request.preferences?.append(notificationPref)
        }
        viewDelegate?.showProgressIndicator(message: LoadingIndicatorMessages.readingPrefernces)
        let api = ProfileApi()
        api.setCompletionHandler{ data, error in
            self.viewDelegate?.hideProgressIndicator()
            if error == nil{
                self.viewDelegate?.showSuccessToastMessage(message: SuccessMessages.preferencesUpdated)
            }else{
                self.viewDelegate?.showErrorToastMessage(message: ErrorMessages.updatingPreferenceFailed)
            }
            
        }
        api.updateNotificationSettings(request: request)
    }
}
class SettingsItem{
    var title = ""
    var menuItems = [UserPreference]()
    var settingsType =  SettingsType.more
    static var languageSettings:SettingsItem{
        let item = SettingsItem()
        item.title = "Language"
        item.settingsType = .language
        let languagePref = UserPreference(id: 1, title: "English", status: 1)
        item.menuItems = [languagePref]
        return item
    }
    
    static var moreActionsSettings  :SettingsItem{
        let item = SettingsItem()
        item.title = "More"
        item.settingsType = .more
        let termsPolicy = UserPreference(id: 1, title: "Terms of Use", status: 1)
        let privacyPolicy = UserPreference(id: 2, title: "Privacy Policy", status: 1)
        let refundPolicy = UserPreference(id: 3, title: "Refund Policy", status: 1)
        item.menuItems = [termsPolicy, privacyPolicy, refundPolicy]
        return item
    }
    
    enum SettingsType: Int{
        case language
        case notification
        case more
    }
}

