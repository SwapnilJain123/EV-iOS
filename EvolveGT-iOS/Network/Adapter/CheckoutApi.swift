//
//  CheckoutApi.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 26/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class CheckoutApi : BaseApiAdapter{
    func fetchCartList(userId: Int){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(CheckoutApiConstants.CART_LIST)"
        var request = UserDataSerialRequest()
        request.userID = userId
        request.isMoto = AppEngine.sharedInstance.isEvApp() ? 0 : 1
        setParameters(parameters: makeDictionary(request))
        setUrl(url: url)
        super.makeRequest(method: .POST)
    }
    
    func validateCoupon(userId: Int, couponCode : String){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(CheckoutApiConstants.VALIDATE_COUPON)"
        let request = ValdateCouponRequest(couponCode: couponCode, userId: userId)
        setParameters(parameters: makeDictionary(request))
        setUrl(url: url)
        super.makeRequest(method: .POST)
    }
    
    func placeOrder(placeOrderRequest: PlaceOrderRequest){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(CheckoutApiConstants.PLACE_ORDER)"
        setParameters(parameters: makeDictionary(placeOrderRequest))
        setUrl(url: url)
        super.makeRequest(method: .POST)
    }
    
    func resetCartList(userId: Int){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(CheckoutApiConstants.RESET_CART)"
        var request = UserDataSerialRequest()
        request.userID = userId
        request.isMoto = AppEngine.sharedInstance.isEvApp() ? 0 : 1
        setParameters(parameters: makeDictionary(request))
        setUrl(url: url)
        super.makeRequest(method: .POST)
    }
    
    func getCheckoutToken(userId: Int, email: String){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(CheckoutApiConstants.CHECKOUT_TOKEN)"
        let request = CheckoutTokenRequest()
        request.email = email
        request.userId = userId
        request.mode = BuildScheme.paymentMode
        
        setParameters(parameters: makeDictionary(request))
        setUrl(url: url)
        super.makeRequest(method: .POST)
    }
    func completeBrainTreeTransaction(request: BrainTreeTransactionRequest){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(CheckoutApiConstants.BRAINTREE_TRANSACTION)"
        
        setParameters(parameters: makeDictionary(request))
        setUrl(url: url)
        super.makeRequest(method: .POST)
    }
}
