//
//  CheckoutRequests.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 29/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct ValdateCouponRequest: Codable{
    var couponCode: String?
    var userId: Int?
    
    enum CodingKeys: String, CodingKey {
        case couponCode = "coupon"
        case userId = "uid"
    }
}
class PlaceOrderRequest : Codable{
    
    var paymentToken, orderID, payerID, paymentID: String?
    
    var  intent = "sale"
    var returnUrl, payment, coupon: String?
    var userId: Int?
    
    enum CodingKeys: String, CodingKey {
        
        case paymentToken
        case orderID
        case payerID
        case paymentID
        case intent
        case returnUrl
        case payment
        case userId = "serial"
        case coupon
        
    }
    
}
class CheckoutTokenRequest : Codable{
    var mode, email: String?
    var userId: Int?
}
class BrainTreeTransactionRequest: Codable{
    var mode, amount, brainTreeNonce, paymentType, coupon: String?
    var userId: Int?
    
    enum CodingKeys: String, CodingKey {
        case mode
        case amount
        case brainTreeNonce = "nonce"
        case userId = "serial"
        case paymentType = "payment"
        case coupon = "coupon"
        
    }
    
}
