//
//  AppDelegate.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 21/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        initiApp()
        return true
    }
    
}

extension AppDelegate{
    
    
    func initiApp(){
        AppEngine.sharedInstance.restoreData()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        launchDashboard()
        setNavBarStyle()
    }
    func launchDashboard(){
        if AppEngine.sharedInstance.isUserLoggedIn(){
            if AppEngine.sharedInstance.currentUser?.isAdmin() ?? false{
                //launch Admin Dashboard
                launchAdminDashboard()
            }else{
                //launch User Dashboard
                launchUserDashboard()
            }
        }else{
            //launch Login View Controller
            launchLoginScreen()
        }
    }
    func launchLoginScreen(){
        let loginStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let loginNav =  loginStoryBoard.instantiateViewController(withIdentifier: "LoginNav") as! UINavigationController
        UIView.transition(with: self.window!, duration: 0.1
            , options: .transitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                self.window?.rootViewController = loginNav
                UIView.setAnimationsEnabled(oldState)
        }, completion: { (finished: Bool) -> () in
        })
        
        self.window?.makeKeyAndVisible()
    }
    func launchUserDashboard(){
        let storboard = UIStoryboard.init(name: "Tabs", bundle: nil)
        
        let tabarCntlr = storboard.instantiateViewController(withIdentifier: "TabView") as! ETTabViewController
        UIView.transition(with: self.window!, duration: 0.1
            , options: .transitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                self.window?.rootViewController = tabarCntlr
                UIView.setAnimationsEnabled(oldState)
        }, completion: { (finished: Bool) -> () in
        })
        self.window?.makeKeyAndVisible()
    }
    func launchAdminDashboard(){
        
        Log.i("Launching Admin Dashboard")
        let adminStorboard = UIStoryboard.init(name: "Admin", bundle: nil)
        let nav =  adminStorboard.instantiateViewController(withIdentifier: "AdminNavVC") as! UINavigationController
        UIView.transition(with: self.window!, duration: 0.1
            , options: .transitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                self.window?.rootViewController = nav
                UIView.setAnimationsEnabled(oldState)
        }, completion: { (finished: Bool) -> () in
        })
        
        self.window?.makeKeyAndVisible()
    }
    func setNavBarStyle(){
        UINavigationBar.appearance().isTranslucent = false
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor =  UIColor.white
        navigationBarAppearace.shadowImage = UIImage()
        navigationBarAppearace.setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
    
    
    func doLogout(){
        AppEngine.sharedInstance.reset()
        launchLoginScreen()
    }
}

