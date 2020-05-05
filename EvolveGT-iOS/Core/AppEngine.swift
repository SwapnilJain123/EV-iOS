//
//  AppEngine.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class AppEngine{
    
    
    enum AppMode: Int{
        case APP_EV
        case APP_MOTO
    }
    static let sharedInstance = AppEngine()
    
    public var userID : String{
        currentUser?.id ?? ""
    }
    
    
    var currentUser : User?
    var userDetails : UserDetails?
    
    var authToken = ""
    private var userDefaultHelper = UserDefaultHelper.sharedInstance
    
    var appMode : AppMode = .APP_EV
    private init(){
        
    }
    
    func switchApp(appMode : AppMode){
        self.appMode = appMode
        
        userDefaultHelper.saveData(key: AppConstants.KEY_APP_MODE, value: self.appMode.rawValue)
    }
    
    func isEvApp() -> Bool{
        return appMode == AppMode.APP_EV
    }
    
    func isUserLoggedIn() -> Bool{
        return currentUser != nil
    }
    
    
    func saveUserInfo(user: User){
        self.currentUser = user
        do{
            let encoder = JSONEncoder()
            let userData = try encoder.encode(user)
            userDefaultHelper.saveData(key: KEY_USER, value: userData)
        }catch{
            Log.e("Saving user info failed")
        }
    }
    
    func restoreData(){
        if let savedUserData = userDefaultHelper.getData(key: KEY_USER) as? Data{
        
            let decoder = JSONDecoder()
            do{
                currentUser = try decoder.decode(User.self, from: savedUserData)
                Log.i("Session restored")
            }catch{
                Log.e("Restoring user info Failed")
            }
        }
        let savedAppMode = userDefaultHelper.getData(key: AppConstants.KEY_APP_MODE) as? Int ?? AppMode.APP_EV.rawValue
        self.appMode = AppMode(rawValue: savedAppMode) ?? AppMode.APP_EV
        authToken = userDefaultHelper.getData(key: KEY_AUTH_TOKEN) as? String ?? ""
        
    }
    
    func saveAuthToken(token : String){
        self.authToken = token
        userDefaultHelper.saveData(key: KEY_AUTH_TOKEN, value: token)
    }
    
    func reset(){
        userDefaultHelper.delete(key: KEY_AUTH_TOKEN)
        userDefaultHelper.delete(key: KEY_USER)
        self.currentUser = nil
        self.authToken = ""
        
    }
}
