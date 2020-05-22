//
//  AlertService.swift
//  Custom Alerts
//
//  Created by Kyle Lee on 2/13/19.
//  Copyright © 2019 Kilo Loco. All rights reserved.
//

import UIKit
struct AlertData {
    var title = ""
    var message = ""
    var btnPositive = "OK"
    var attributedMessage : NSAttributedString? = nil
    
    var titleBackgroundColor : UIColor = .getBackgroundGray()
    var titleTextColor : UIColor = .white
    var alertBackgroundColor : UIColor = .white
    var btnPositiveTextColor : UIColor = .white
    var btnPositiveBackroundColor : UIColor = .getAppThemeColor()
     var btnPositiveTintColor : UIColor = .getSecondaryColor()
    var positiveBtnAction : (() -> Void)? = nil
    
    var messageAlignment : NSTextAlignment = .center
}


class AlertService {
    
    func alert(title: String, buttonTitle: String, completion: @escaping () -> Void = {}) -> AlertViewController {
        
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: .main)
        
        let alertVC = storyboard.instantiateViewController(withIdentifier: "AlertVC") as! AlertViewController
        
        alertVC.alertTitle = title
        alertVC.actionButtonTitle = buttonTitle
        
        alertVC.buttonAction = completion
        
        return alertVC
    }
    
    static func createAlertController(alertData : AlertData) -> SimpleAlertController {
        
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: .main)
        
        let alertVC = storyboard.instantiateViewController(withIdentifier: "SimpleAlertVC") as! SimpleAlertController
        
        alertVC.providesPresentationContextTransitionStyle = true
               alertVC.definesPresentationContext = true
               alertVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
               alertVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        alertVC.alertData = alertData
        
        return alertVC
    }
    
}
