//
//  CheckoutResponse.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 26/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class CartListResponse : Codable{
    
    var cartList: [CartItem]?
    var walletEnabled: Int?
    var wallet: String?

    enum CodingKeys: String, CodingKey {
        case cartList = "data"
        case walletEnabled, wallet
    }
}

struct CouponValidationResponse: Codable {
    var couponBalance : String?
    enum CodingKeys: String, CodingKey {
           case couponBalance = "remain"
       }
    
}

struct PlaceOrderResponse: Codable {
    var transactionID : String?
    enum CodingKeys: String, CodingKey {
           case transactionID = "ack_id"
       }
    
}
