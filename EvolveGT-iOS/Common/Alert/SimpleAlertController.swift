//
//  SimpleAlertController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 19/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
class SimpleAlertController : UIViewController{
    
    
    @IBOutlet weak var rootView: UIView!
    
    @IBOutlet weak var titleBackgroundView: UIView!
    
    var alertData = AlertData()

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var btnPositive: UIButton!
    @IBOutlet weak var alertTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.showRoundCorner(roundCorner: 5)
        
        alertTitle.text = alertData.title
        btnPositive.setTitle(alertData.btnPositive, for: .normal)
        if alertData.attributedMessage == nil{
            messageLabel.text = alertData.message
        }else{
            messageLabel.attributedText = alertData.attributedMessage
        }
        
        messageLabel.textAlignment = alertData.messageAlignment
        rootView.backgroundColor = alertData.alertBackgroundColor
        titleBackgroundView.backgroundColor = alertData.titleBackgroundColor
        alertTitle.textColor = alertData.titleTextColor
        
        btnPositive.setTitleColor(alertData.btnPositiveTextColor, for: .normal)
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
               if let context = UIGraphicsGetCurrentContext() {
                context.setFillColor(alertData.btnPositiveBackroundColor.cgColor)
                   context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
                   let colorImage = UIGraphicsGetImageFromCurrentImageContext()
                   UIGraphicsEndImageContext()
                   btnPositive.setBackgroundImage(colorImage, for: .normal)
               }
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
                      if let context = UIGraphicsGetCurrentContext() {
                       context.setFillColor(alertData.btnPositiveTintColor.cgColor)
                          context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
                          let colorImage = UIGraphicsGetImageFromCurrentImageContext()
                          UIGraphicsEndImageContext()
                          btnPositive.setBackgroundImage(colorImage, for: .highlighted)
                      }
        btnPositive.tintColor = .black
        
        
        if alertData.title.isEmpty{
            titleBackgroundView.removeFromSuperview()
        }
        
    }
    @IBAction func didPressPositiveButton(_ sender: UIButton) {
        if let action = alertData.positiveBtnAction{
            action()
        }
        
        dismiss(animated: true, completion: nil)
    }
}

