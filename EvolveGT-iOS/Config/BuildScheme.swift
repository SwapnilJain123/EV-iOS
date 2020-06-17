//
//  BuildScheme.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 10/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class BuildScheme{
    private static var buildMode :String {
        
        return  Config.BUILD_CONFIG
    }
    
    static var brainTreeReturnUrl :String {
        
        return  Config.BRAINTREE_RETURN_URL
    }
    
    static var paymentMode :String {
        Config.CHECKOUT_MODE
    }
    
    static var isBuildQA : Bool {
        return "QA" == BuildScheme.buildMode
    }
    
    static func getBuildVersion() -> String{
        let versionCode: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String? as AnyObject?
        return versionCode as? String ?? "1.0"
    }
}
