//
//  CheckoutApi.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 26/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class CheckoutApi : BaseApiAdapter{
    func fetchCartList(userId: String){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(CheckoutApiConstants.CART_LIST)"
        let request = UserDataSerialRequest(userID: userId)
        setParameters(parameters: makeDictionary(request))
        setUrl(url: url)
        super.makeRequest(method: .POST)
    }
    
    func validateCoupon(userId: String, couponCode : String){
        
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
    
    func resetCartList(userId: String){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(CheckoutApiConstants.RESET_CART)"
        let request = UserDataSerialRequest(userID: userId)
        setParameters(parameters: makeDictionary(request))
        setUrl(url: url)
        super.makeRequest(method: .POST)
    }
}
