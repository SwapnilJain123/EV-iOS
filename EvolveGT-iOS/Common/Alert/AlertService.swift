//
//  AlertService.swift
//  Custom Alerts
//
//  Created by Kyle Lee on 2/13/19.
//  Copyright © 2019 Kilo Loco. All rights reserved.
//

import UIKit

class AlertService {
    
    func alert(title: String, buttonTitle: String, completion: @escaping () -> Void = {}) -> AlertViewController {
        
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: .main)
        
        let alertVC = storyboard.instantiateViewController(withIdentifier: "AlertVC") as! AlertViewController
        
        alertVC.alertTitle = title
        alertVC.actionButtonTitle = buttonTitle
        
        alertVC.buttonAction = completion
        
        return alertVC
    }
}
