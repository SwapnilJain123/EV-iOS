//
//  CheckoutApiConstant.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 26/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct CheckoutApiConstants{
    static let CART_LIST = "cart/beforeOrder"
    static let DELET_USER = "user/deletemember"

    static let VALIDATE_COUPON = "checkout/validateCoupon"
    
    static let PLACE_ORDER = "checkout/placeOrder"
    static let RESET_CART = "checkout/resetCart"
    
    //Mark:- BrainTree
    
    static let CHECKOUT_TOKEN = "braintree/token"
     static let BRAINTREE_TRANSACTION = "braintree/transaction"
    static let TERMSANDCONDITIONS = "user/legalPolicies?policy_type=terms-policy"
    static let CANCELLATIONPOLICY = "user/legalPolicies?policy_type=cancellation-policy"
    static let PRIVACY_POLICY = "user/legalPolicies?policy_type=privacy-policy"


//    [DOMAIN]/ontrack-api/public/app/v3/user/legalPolicies?policy_type=terms-policy
//    [DOMAIN]/ontrack-api/public/app/v3/user/legalPolicies?policy_type=privacy-policy
//    [DOMAIN]/ontrack-api/public/app/v3/user/legalPolicies?policy_type=refund-policy
//    [DOMAIN]/ontrack-api/public/app/v3/user/legalPolicies?policy_type=cancellation-policy
}
//https://qa.asraracing.com/ontrack-api/public/app/v3/themeSettings/fetch
