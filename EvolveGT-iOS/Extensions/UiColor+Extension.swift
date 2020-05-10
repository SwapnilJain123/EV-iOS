//
//  UiColor+Extension.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 24/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static let COLOR_EV = "#08a53a"
    static let COLOR_MOTO = "#376cde"
    
    
    static func getAppThemeColor() -> UIColor{
        var appColor = UIColor.init(hexFromString: UIColor.COLOR_EV)
        if(AppEngine.sharedInstance.appMode != .APP_EV){
            appColor = UIColor.init(hexFromString: UIColor.COLOR_MOTO)
        }
        
        return appColor
        
    }
    
    static func getEvColor() -> UIColor{
        UIColor.init(hexFromString: UIColor.COLOR_EV)
    }
    
    static func getMotoColor() -> UIColor{
        UIColor.init(hexFromString: UIColor.COLOR_MOTO)
    }
    
    convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
        var cString:String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
