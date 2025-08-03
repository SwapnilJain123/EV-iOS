//
//  ConfigAppStore.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 17/06/20.
//  Copyright ©2020 YaraTech. All rights reserved.
//

import Foundation
struct Config {
    
    //QA
    //static let BASE_URL = "qa.asraracing.com"

    //live
    static let BASE_URL = "asraracing.com"
    static let LOG_ENABLED = false
    static let BUILD_CONFIG = "AppStore"
    static let CHECKOUT_MODE = "production"
    static let BUNDLE_ID = "com.asra.appstore"
    static let BRAINTREE_RETURN_URL = "com.asra.appstore.payments"
}
