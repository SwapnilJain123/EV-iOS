//
//  ViewControllerExtension.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import Loaf
extension UIViewController{
    
    public class Ext {
        init(vc : UIViewController){
            self.vc = vc
        }
        var vc : UIViewController
        
        func showAlert(title: String?, message: String?, handler: (()->Void)? = nil) {
            let alerController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel){ alertAction in
                if let safeHandler = handler{
                    safeHandler()
                }
            }
            alerController.addAction(cancelAction)
            vc.present(alerController, animated: true, completion: nil)
        }
        
        func confirmationAlert(title: String?, message: String?, btnText : String, handler: @escaping (()->Void)) {
            let alerController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: btnText, style: .default){ alertAction in
                // alerController.dismiss(animated: false, completion: nil)
                handler()
            }
            alerController.addAction(confirmAction)
            
            alerController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            vc.present(alerController, animated: true, completion: nil)
        }
        
        func addLoadingIndicator(_ message: String?){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.150, execute: {
                // MBProgressHUD.showAdded(to: self.view, animated: true)
                SVProgressHUD.setMinimumSize(CGSize(width: 250.0, height: 150.0))
                SVProgressHUD.setDefaultMaskType(.black)
                SVProgressHUD.show(withStatus: message)
            })
        }
        
        func removeLoadingIndicator(){
            //MBProgressHUD.hide(for: self.view, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.150, execute: {
                SVProgressHUD.dismiss()
            })
            
        }
        func removeLoadingIndicatorImmediately(){
            //MBProgressHUD.hide(for: self.view, animated: true)
            SVProgressHUD.dismiss()
            
        }
        
        func showNavbar(){
            vc.navigationController?.isNavigationBarHidden = false
            
        }
        
        func hideNavbar(){
            vc.navigationController?.isNavigationBarHidden = true
            
        }
        
        private static let ERROR_VIEW_TAG = -1
        private static let ERROR_MESSAGE_VIEW_TAG = -2
        func displayEmptyMessage(message: String){
            
            if let existingView = vc.view.viewWithTag(UIViewController.Ext.ERROR_VIEW_TAG){
                
                if let labelView = existingView.viewWithTag(UIViewController.Ext.ERROR_MESSAGE_VIEW_TAG) as? UILabel{
                    labelView.text          = message
                    existingView.isHidden = false
                }
                
            }else{
                
                let containerView = UIView(frame: CGRect(x: 0, y: 0, width: vc.view.bounds.size.width, height: vc.view.bounds.size.height))
                containerView.backgroundColor = .lightText
                containerView.tag = UIViewController.Ext.ERROR_VIEW_TAG
                
                let errorView: UILabel  = UILabel(frame: CGRect(x: 10, y: 0, width: vc.view.bounds.size.width - 30, height: vc.view.bounds.size.height))
                errorView.text          = message
                errorView.numberOfLines = 0
                errorView.tag = UIViewController.Ext.ERROR_MESSAGE_VIEW_TAG
                
                
                errorView.textColor     = UIColor.black
                errorView.textAlignment = .center
                containerView.addSubview(errorView)
                vc.view.addSubview(containerView)
                
                self.removeLoadingIndicator()
            }
        }
        
        
        func hideErrorView(){
            if let existingView = vc.view.viewWithTag(UIViewController.Ext.ERROR_VIEW_TAG){
                existingView.isHidden = true
                Log.i("Error View Hidden")
            }else{
                Log.e("Error View Not Found")
            }
        }
        func showSuccessToast(message: String, handler: (()->Void)? = nil){
            Loaf(message, state: .custom(.init(backgroundColor: UIColor.getAppThemeColor(), icon: Loaf.Icon.success, width: .screenPercentage(0.8))), sender: vc).show(){ dismissalType in
                if handler != nil{
                    handler!()
                }
            }
        }
        func showErrorToast(message: String, handler: (()->Void)?){
            Loaf(message, state: .custom(.init(backgroundColor: UIColor.red, icon: Loaf.Icon.error, width: .screenPercentage(0.8))), sender: vc).show(){ dismissalType in
                if handler != nil{
                    handler!()
                }
            }
        }
        
        func showBackButton(){
            vc.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        func backButtonToRootViewController(){
            
                vc.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.didPressBackButton))
            
        }
        
        @objc func didPressBackButton(){
            vc.navigationController?.popViewController(animated: true)
        }
        
        func hideBackButton(){
            vc.navigationItem.setHidesBackButton(true, animated: true)
        }
        
        func setNavigationBackgroundColor(color: UIColor){
            //            let navigationBarAppearace = UINavigationBar.appearance()
            //            navigationBarAppearace.barTintColor = color
            
            vc.navigationController?.navigationBar.barTintColor = color
        }
        func setScreenTitle(title: String)
        {
            guard vc.navigationController != nil else { return }
            let barButtonItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
            barButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)],
                                                 for: .normal)
            //        navigationItem.leftItemsSupplementBackButton = needsDefaultBack
            //        navigationItem.leftBarButtonItem = barButtonItem
            vc.title = title
        }
        
        
        func pushViewController(storyBoard : String, VCIdentifier : String){
            let storyBoard: UIStoryboard = UIStoryboard(name: storyBoard, bundle: nil)
            let destination = storyBoard.instantiateViewController(withIdentifier: VCIdentifier)
            vc.navigationController?.pushViewController(destination, animated: true)
        }
        
        func pushViewController(viewController : UIViewController){
            
            vc.navigationController?.pushViewController(viewController, animated: true)
        }
        
        func presentViewController(storyBoard : String, VCIdentifier : String){
            let storyBoard: UIStoryboard = UIStoryboard(name: storyBoard, bundle: nil)
            let destination = storyBoard.instantiateViewController(withIdentifier: VCIdentifier)
            vc.present(destination, animated: true)
        }
        
        func getViewController(storyBoard : String, VCIdentifier : String) -> UIViewController{
            let storyBoard: UIStoryboard = UIStoryboard(name: storyBoard, bundle: nil)
            let destination = storyBoard.instantiateViewController(withIdentifier: VCIdentifier)
            return destination
        }
        
        func getAppWindow () -> UIWindow?{
            let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
            return appDelegate?.window
        }
        
        func openLink(_ url: String){
            guard let url = URL(string: url) else { return }
            UIApplication.shared.open(url)
        }
        
        
        func presentOptions(title: String, message: String, options: [String], selected : String?, completionHandler : @escaping (String)->Void){
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            for option in options{
                let action = UIAlertAction(title: option, style: .default) {
                    UIAlertAction in
                    completionHandler(option)
                }
                alert.addAction(action)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
                UIAlertAction in
                // It will dismiss action sheet
            }
            alert.addAction(cancelAction)
            vc.present(alert, animated: false, completion: nil)
        }
        
        func showAlertWithAttributedText(title: String, text: NSAttributedString, action : (() -> Void)?){
            var alertData = AlertData()
            alertData.title = title
            alertData.attributedMessage = text
            alertData.positiveBtnAction = action
            let alertVC = AlertService.createAlertController(alertData: alertData)
            vc.present(alertVC, animated: true, completion: nil)
            
            
        }
        
        func showSimpleAlert(title: String, text: String){
            var alertData = AlertData()
            alertData.title = title
            alertData.message = text
            let alertVC = AlertService.createAlertController(alertData: alertData)
            vc.present(alertVC, animated: true, completion: nil)
            
            
        }
    }
    var ext: Ext {
        return  Ext(vc: self)
        
    }
}
extension UIViewController{
    public class DashboardManager {
        init(vc : UIViewController){
            self.vc = vc
        }
        var vc : UIViewController
        
        func switchToAdminDashboard () {
            let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.launchAdminDashboard()
        }
        
        func switchToUserDashboard () {
            let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.launchUserDashboard()
        }
        
        func logout () {
            vc.ext.addLoadingIndicator(LoadingIndicatorMessages.loggingOut)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + AppConstants.LOGOUT_TIMEOUT, execute: {
                Log.d("Logout !!")
                let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                self.vc.ext.removeLoadingIndicator()
                appDelegate?.doLogout()
            })
            
            
        }
        
        @objc func switchAppMode(){
            
            Log.d("AppMode - Before - \(AppEngine.sharedInstance.isEvApp())")
            let appMode = AppEngine.sharedInstance.isEvApp() ? AppEngine.AppMode.APP_MOTO : AppEngine.AppMode.APP_EV
            AppEngine.sharedInstance.switchApp(appMode: appMode)
            
            Log.d("AppMode - After  - \(AppEngine.sharedInstance.isEvApp())")
            vc.ext.setNavigationBackgroundColor(color: UIColor.getAppThemeColor())
            self.applyThemeToDividers()
            vc.didChangeAppTheme()
        }
        func applyThemeToDividers(){
            func getDividersInView(view: UIView) -> [DividerView] {
                var results = [DividerView]()
                
                for subview in view.subviews as [UIView] {
                    
                    if let labelView = subview as? DividerView {
                        results += [labelView]
                    } else {
                        results += getDividersInView(view: subview)
                    }
                }
                return results
            }
            
            let dividers = getDividersInView(view: vc.view)
            
            let appColor = UIColor.getAppThemeColor()
            for divider in dividers{
                divider.backgroundColor = appColor
            }
        }
        
    }
    var dashboardManager: DashboardManager {
        return  DashboardManager(vc: self)
    }
}
