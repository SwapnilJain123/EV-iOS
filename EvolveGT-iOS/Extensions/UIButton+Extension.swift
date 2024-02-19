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
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.clear.cgColor
        
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
            context.setFillColor(UIColor.lightGray.cgColor)
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
    
    func setBackgroundColor(color: UIColor){
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: .normal)
        }
    }
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
    
    func applyPlusButtonTheme(){
//        if AppEngine.sharedInstance.isEvApp(){
//            
//            let normalPlusImage = UIImage(named: "ic_btn_plus_green")
//            let selectionPlusImage = UIImage(named: "ic_btn_plus_green_lite")
//            
//            self.setImage(normalPlusImage, for: .normal)
//            self.setImage(selectionPlusImage, for: .highlighted)
//            self.setImage(selectionPlusImage, for: .selected)
//            
//        }else{
//            let normalPlusImage = UIImage(named: "ic_btn_plus_blue")
//            let selectionPlusImage = UIImage(named: "plus_blue_lite")
//            
//            self.setImage(normalPlusImage, for: .normal)
//            self.setImage(selectionPlusImage, for: .highlighted)
//            self.setImage(selectionPlusImage, for: .selected)
//            
//        }
//        
        let normalPlusImage = UIImage(named: "ic_btn_plus_blue")
        let selectionPlusImage = UIImage(named: "plus_blue_lite")
        
        self.setImage(normalPlusImage, for: .normal)
        self.setImage(selectionPlusImage, for: .highlighted)
        self.setImage(selectionPlusImage, for: .selected)

    }
    func applyMinusButtonTheme(){
//        if AppEngine.sharedInstance.isEvApp(){
//
//
//            let normalMinusImage = UIImage(named: "ic_btn_minus_green")
//            let selectionMinusImage = UIImage(named: "ic_btn_minus_green_lite")
//
//            self.setImage(normalMinusImage, for: .normal)
//            self.setImage(selectionMinusImage, for: .highlighted)
//            self.setImage(selectionMinusImage, for: .selected)
//        }else{
//
//            let normalMinusImage = UIImage(named: "ic_btn_minus_blue")
//            let selectionMinusImage = UIImage(named: "ic_btn_minus_blue_lite")
//            self.setImage(normalMinusImage, for: .normal)
//            self.setImage(selectionMinusImage, for: .highlighted)
//            self.setImage(selectionMinusImage, for: .selected)
//
//        }
        
        let normalMinusImage = UIImage(named: "ic_btn_minus_blue")
        let selectionMinusImage = UIImage(named: "ic_btn_minus_blue_lite")
        self.setImage(normalMinusImage, for: .normal)
        self.setImage(selectionMinusImage, for: .highlighted)
        self.setImage(selectionMinusImage, for: .selected)

    }
    
    func applyEditButtonTheme(){
        if AppEngine.sharedInstance.isEvApp(){
            
            
            let normalEditImage = UIImage(named: "ic_ev_edit")
            let selectionEditImage = UIImage(named: "ic_ev_edit_lite")
            
            self.setImage(normalEditImage, for: .normal)
            self.setImage(selectionEditImage, for: .highlighted)
            self.setImage(selectionEditImage, for: .selected)
        }else{
            
            let normalEditImage = UIImage(named: "ic_moto_edit")
            let selectionEditImage = UIImage(named: "ic_moto_edit_lite")
            self.setImage(normalEditImage, for: .normal)
            self.setImage(selectionEditImage, for: .highlighted)
            self.setImage(selectionEditImage, for: .selected)
            
        }
    }
    
    func applyBoarderColorTheme(){
        self.backgroundColor = .clear
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.getAppThemeColor().cgColor
        self.setTitleColor(.getAppThemeColor(), for: .normal)
        setBackgroundColor(color: .clear)
    }
    
    func setBorderColor(color: UIColor){
        self.backgroundColor = .clear
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2
        self.layer.borderColor = color.cgColor
        self.setTitleColor(color, for: .normal)
        setBackgroundColor(color: .clear)
    }
}
