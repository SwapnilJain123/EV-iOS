//
//  UIButtonExtension.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 10/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
    func applyColorTheme(){
        
        self.backgroundColor = UIColor.getAppThemeColor()
        
        
        self.clipsToBounds = true  // add this to maintain corner radius
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(UIColor.getAppThemeColor().cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: .normal)
        }
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(UIColor.getSecondaryColor().cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: .highlighted)
        }
        
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
               if let context = UIGraphicsGetCurrentContext() {
                   context.setFillColor(UIColor.darkGray.cgColor)
                   context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
                   let colorImage = UIGraphicsGetImageFromCurrentImageContext()
                   UIGraphicsEndImageContext()
                   self.setBackgroundImage(colorImage, for: .disabled)
               }
        
        self.tintColor = .black
       
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(.lightGray, for: .highlighted)
         self.setTitleColor(.white, for: .disabled)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        let text = self.title(for: .normal)
        self.setTitle(text?.uppercased(), for: .normal)
    }
}
