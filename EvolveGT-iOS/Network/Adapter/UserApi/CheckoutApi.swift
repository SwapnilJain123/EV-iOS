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
}
