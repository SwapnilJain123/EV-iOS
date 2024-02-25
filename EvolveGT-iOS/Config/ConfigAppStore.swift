//
//  ConfigAppStore.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 17/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct Config{
//    static let BASE_URL = "evolvegt.webeteerprojects.com" //staging
//    static let BASE_URL = "qa.evolvegt.com" //release2 uploaded the code on git

//    static let BASE_URL_DeleteAPI = "https://qa-race.asraracing.com/ev-angular-api/public/admin/deletemember" //release3 uploaded the code on git
    
    ///staging
    static let BASE_URL = "qa.asraracing.com"
    ///Live
//    static let BASE_URL = "asraracing.com"


    static let LOG_ENABLED = false
    static let BUILD_CONFIG = "AppStore"
    static let CHECKOUT_MODE = "production"
    static let BUNDLE_ID = "com.asra.appstore"
    static let BRAINTREE_RETURN_URL = "com.evolve.appstore.payments"
}
