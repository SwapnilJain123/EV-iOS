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
        func addLoadingIndicator(_ message: String?){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.150, execute: {
                // MBProgressHUD.showAdded(to: self.view, animated: true)
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
        
        static let ERROR_VIEW_TAG = -1
        func displayEmptyMessage(message: String){
            
            if let existingView = vc.view.viewWithTag(UIViewController.Ext.ERROR_VIEW_TAG){
                existingView.removeFromSuperview()
            }
            
            let errorView: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: vc.view.bounds.size.width, height: vc.view.bounds.size.height))
            errorView.text          = message
            errorView.numberOfLines = 0
            errorView.tag = UIViewController.Ext.ERROR_VIEW_TAG
            errorView.backgroundColor = UIColor.init(hexFromString: "#F9FAF7")
            errorView.textColor     = UIColor.black
            errorView.textAlignment = .center
            vc.view.addSubview(errorView)
            
            self.removeLoadingIndicator()
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
        
        func hideBackButton(){
            vc.navigationItem.setHidesBackButton(true, animated: true);
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
        
        func getViewController(storyBoard : String, VCIdentifier : String) -> UIViewController{
            let storyBoard: UIStoryboard = UIStoryboard(name: storyBoard, bundle: nil)
            let destination = storyBoard.instantiateViewController(withIdentifier: VCIdentifier)
                  return destination
        }
        
    }
    var ext: Ext {
        return  Ext(vc: self)
        
    }
}

