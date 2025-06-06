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
    
//    private static let COLOR_EV = "#08A53A"
//    private static let COLOR_MOTO = "#376cde"
    private static let COLOR_EV = "#376cde"
    private static let COLOR_MOTO = "#08A53A"

//    private static let COLOR_EV_LITE = "#00574B"
//    private static let COLOR_MOTO_LITE = "#151E49"
    private static let COLOR_EV_LITE = "#151E49"
    private static let COLOR_MOTO_LITE = "#00574B"

//    static let GREEN_EV_LITE = "#11C248"
//    static let GREEN_EV_DARK = "#08A43A"
//    static let BLUE_MOTO_LITE = "#7189E7"
//    static let BLUE_MOTO_DARK = "#3853C2"
//    static let GREEN_EV_LITE = "#7189E7"
//    static let GREEN_EV_DARK = "#3853C2"
    static let BLUE_MOTO_LITE = "#376cde"
    static let BLUE_MOTO_DARK = "#3750de"

    private static let BACKGROUND_GRAY = "#787878"
    
//    private static let EVOLVE_LIGHT_BACKGROUND = "#b3f5c4"
//    private static let MOTO_LIGHT_BACKGROUND = "#94a2d1"
    private static let EVOLVE_LIGHT_BACKGROUND = "#94a2d1"
    private static let MOTO_LIGHT_BACKGROUND = "#b3f5c4"

    private static let INACTIVE_GRAY = "#E6E6E6"
    private static let EV_TAB_BACKGROUND = "#333333"
    
     private static let GRADIENT_START = "#FAFEFD"
     private static let GRADIENT_EV_END = "#96CDA6"
     private static let GRADIENT_MOTO_END = "#3853C2"
    
    
    // - EV Start, 96CDA6 end
    //FAFEFD - Moto Start, 4763d1 end
    
    static func getGradientStart() -> UIColor{
        UIColor.init(hexFromString: UIColor.GRADIENT_START)
    }
    static func getGradientEVEnd() -> UIColor{
        UIColor.init(hexFromString: UIColor.GRADIENT_EV_END)
    }
    static func getGradientMotoEnd() -> UIColor{
        UIColor.init(hexFromString: UIColor.GRADIENT_MOTO_END)
    }
    
    static func getBackgroundGray() -> UIColor{
        UIColor.init(hexFromString: UIColor.BACKGROUND_GRAY)
    }
    
    static func getEVTabBackgroundGray() -> UIColor{
        UIColor.init(hexFromString: UIColor.EV_TAB_BACKGROUND)
    }
    
    static func getAppThemeColor() -> UIColor{
        var appColor = UIColor.init(hexFromString: UIColor.COLOR_EV)
        if(AppEngine.sharedInstance.appMode != .APP_EV){
            appColor = UIColor.init(hexFromString: UIColor.COLOR_MOTO)
        }
        return appColor
    }
    
    static func getSecondaryColor() -> UIColor{
        var appColor = UIColor.init(hexFromString: UIColor.COLOR_EV_LITE)
        if(AppEngine.sharedInstance.appMode != .APP_EV){
            appColor = UIColor.init(hexFromString: UIColor.COLOR_MOTO_LITE)
        }
        
        return appColor
        
    }
    
    static func getLightBackgroundColor() -> UIColor{
           var appColor = UIColor.init(hexFromString: UIColor.EVOLVE_LIGHT_BACKGROUND)
           if(AppEngine.sharedInstance.appMode != .APP_EV){
               appColor = UIColor.init(hexFromString: UIColor.MOTO_LIGHT_BACKGROUND)
           }
           
           return appColor
           
       }
    
    static func getEvColor() -> UIColor{
        UIColor.init(hexFromString: UIColor.COLOR_EV)
    }
    
    static func getMotoColor() -> UIColor{
        UIColor.init(hexFromString: UIColor.COLOR_MOTO)
    }
    static func getInactiveGray() -> UIColor{
        UIColor.init(hexFromString: UIColor.INACTIVE_GRAY)
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
