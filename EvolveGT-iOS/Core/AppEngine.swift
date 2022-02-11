//
//  AppEngine.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class AppEngine{
    
    
    var buildMode = ""
    enum AppMode: Int{
        case APP_EV
        case APP_MOTO
    }
    static let sharedInstance = AppEngine()
    
    public var userID : String{
        currentUser?.id ?? ""
    }
    
    public var userRole : String{
        currentUser?.role ?? "guest"
    }
    
    var countries = [Country]()
    var generalSkills = [String]()
    var states = [SupportedState]()
    
    var currentUser : User?
    var userDetails : UserDetails?
    var membership : String?
    var emergencyContact : EmergencyContact? = nil
    
    var authToken = ""
    private var userDefaultHelper = UserDefaultHelper.sharedInstance
    
    var walletEnabled = false
    var walletBalance: Double = 0
    var cartListCount = 0{
        didSet{
            
        }
    }
    
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
    
    var canCancelEvent : Bool{
        userDetails?.eventCancel ?? false
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
        userDefaultHelper.delete(key: AppConstants.DEVICE_TOKEN)
        userDefaultHelper.delete(key: AppConstants.KEY_DEVICE_TOKEN_STATUS)
        self.currentUser = nil
        self.authToken = ""
        walletEnabled = false
        walletBalance = 0
        cartListCount = 0
        membership = ""
        userDetails = nil
    }
    
   var passportId = ""
   var eventId = ""
   var trackName = ""
   var eventDate = ""
}
