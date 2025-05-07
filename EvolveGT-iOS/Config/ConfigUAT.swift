//
//  ConfigUAT.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 17/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct Config{
   
    //stagung
    static let BASE_URL = "tracknutts.com"

    //live
   // static let BASE_URL = "evolvegt.com"
    static let LOG_ENABLED = true
    static let BUILD_CONFIG = "UAT"
    static let CHECKOUT_MODE = "sandbox"
    static let BUNDLE_ID = "com.evolve.uat"
    static let BRAINTREE_RETURN_URL = "com.evolve.uat.payments"
}
