//
//  AppDelegate.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 21/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SideMenuSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var categories: [ProductCategory] = []
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if ProcessInfo.processInfo.arguments.contains("UI-Testing"){
            BuildScheme.uiTestingOn = true
            UserDefaultHelper.sharedInstance.clear()
            Log.d("UI Testing - clear user defaults")
            
            MockResponseProvider.processTestSetup(data: ProcessInfo.processInfo.environment)
        }
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        initiApp()
        initFirebase()
        registerForPushNotification(application)
        setUpBrainTreeUrlScheme()
        
        //handle notification if launch option is from remote notification
        
        if launchOptions?[.remoteNotification] == nil {
           launchDashboard(payload: nil)
            // Log.d("Launching Via Push!  - Remote options available")
        }

        Log.d("Bundle ID = \(Bundle.main.bundleIdentifier ?? "Not Available")")
        checkForUpdateAndShowAlert()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleLogout), name: .logoutNotification, object: nil)

        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .logoutNotification, object: nil)
    }

//    func applicationDidBecomeActive(_ application: UIApplication) {
//        checkForUpdateAndShowAlert()
//    }

    func checkForUpdateAndShowAlert() {
        checkForUpdate { isUpdateAvailable in
            DispatchQueue.main.async {
                if isUpdateAvailable {
                    self.showUpdateAlert()
                }
            }
        }
    }
    
    @objc func handleLogout() {
        doLogout()
    }

    func initFirebase(){
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
    }
    
    func registerForPushNotification(_ application: UIApplication){
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        //Solicit permission from user to receive notifications
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (_, error) in
            guard error == nil else{
                print(error!.localizedDescription)
                return
            }
        }
        //Deepak
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let token = token {
                print("Remote instance ID token: \(token)")
            }
        }

        //get application instance ID
//        InstanceID.instanceID().instanceID { (result, error) in
//            if let error = error {
//                print("Error fetching remote instance ID: \(error)")
//            } else if let result = result {
//                print("Remote instance ID token: \(result.token)")
//            }
//        }
        
        application.registerForRemoteNotifications()
    }
    
}

extension AppDelegate{
    
    func setUpBrainTreeUrlScheme(){
//        BTAppSwitch.setReturnURLScheme(BuildScheme.brainTreeReturnUrl)
//        Log.d("Brain Tree Return URl = \(BuildScheme.brainTreeReturnUrl)")
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url)

//        if url.scheme?.localizedCaseInsensitiveCompare(BuildScheme.brainTreeReturnUrl) == .orderedSame {
//            return BTAppSwitch.handleOpen(url, options: options)
//        }
        return false
    }
    
    func initiApp(){
        AppEngine.sharedInstance.restoreData()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        setNavBarStyle()
    }
    func launchDashboard(payload: [AnyHashable: Any]?){
        if AppEngine.sharedInstance.isUserLoggedIn(){
            if AppEngine.sharedInstance.currentUser?.isAdmin() ?? false{
                //launch Admin Dashboard
                launchAdminDashboard()
            }else{
                //launch User Dashboard
                launchUserDashboard(payload: payload)
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
    func launchUserDashboard(payload: [AnyHashable: Any]?){
        
        let slideMenuStoryBoard = UIStoryboard.init(name: "SlideMenu", bundle: nil)
        let sideMenuVC = slideMenuStoryBoard.instantiateViewController(withIdentifier: "SlideMenuVC") as! HambergerMenuController
        
        let storboard = UIStoryboard.init(name: "Tabs", bundle: nil)
        
        let tabbarCntlr = storboard.instantiateViewController(withIdentifier: "TabView") as! ETTabViewController
        tabbarCntlr.notificationPayload = payload
        
        UIView.transition(with: self.window!, duration: 0.1
            , options: .transitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                
                let sideMenuController = SideMenuController(contentViewController: tabbarCntlr,
                                                            menuViewController: sideMenuVC)
                let navigationController = UINavigationController(rootViewController: sideMenuController)
                
                navigationController.view.backgroundColor = UIColor.getAppThemeColor()
                navigationController.isNavigationBarHidden = true
                self.window?.rootViewController = navigationController
                
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
    
    func pushToNewNavigationController(viewController: UIViewController){
        
        let nav =  UINavigationController(rootViewController: viewController)
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
extension AppDelegate: UNUserNotificationCenterDelegate{
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([.alert,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        let userInfo = response.notification.request.content.userInfo
        
        
        // Print full message.
        print("Push Payload:\(userInfo)")
        
        Log.i("Type: \(userInfo["type"] ?? "No Type Found")")
         Log.i("Type: \(userInfo["url"] ?? "No URL Found")")
        
         Log.d("Launching Via Push!  - NotificationCenter")
        self.launchDashboard(payload: userInfo)
        
        completionHandler()
    }
    
}
extension AppDelegate:MessagingDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken)")
        
        UserDefaults.standard.set(fcmToken, forKey: AppConstants.DEVICE_TOKEN)
        UserDefaults.standard.synchronize()
        
    }
    
}

//force update the app
extension AppDelegate {
    func checkForUpdate(completion: @escaping (Bool) -> Void) {
        guard let infoDictionary = Bundle.main.infoDictionary,
              let currentVersion = infoDictionary["CFBundleShortVersionString"] as? String,
              let identifier = infoDictionary["CFBundleIdentifier"] as? String else {
            completion(false)
            return
        }
        
        let url = URL(string: "https://itunes.apple.com/lookup?bundleId=com.asra.appstore")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let results = json["results"] as? [[String: Any]],
                   let appStoreVersion = results.first?["version"] as? String {
                    completion(appStoreVersion != currentVersion)
                } else {
                    completion(false)
                }
            } catch {
                completion(false)
            }
        }
        
        task.resume()
    }

    func showUpdateAlert() {
        // Create the alert controller
        let alert = UIAlertController(title: "Update Available", message: "A new version of the app is available. Please update to the latest version.", preferredStyle: .alert)
        
        // Add an action to the alert
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { _ in
            if let url = URL(string: "itms-apps://itunes.apple.com/app/6445951859") {
                UIApplication.shared.open(url)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        // Get the root view controller
        if let rootViewController = window?.rootViewController {
            // Present the alert
            rootViewController.present(alert, animated: true, completion: nil)
        }
    }
}
