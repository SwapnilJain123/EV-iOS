//
//  CartApi.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 14/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class CartApi : BaseApiAdapter{
    
    func addMotoEventToCart(eventRequest: EventCartRequest){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(CartApiConstants.ADD_MOTO_EVENT_TO_CART)"
        setUrl(url: url)
        setParameters(parameters: makeDictionary(eventRequest))
        super.makeRequest(method: .POST)
    }
    func addEvolveEventToCart(eventRequest: EventCartRequest){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(CartApiConstants.ADD_EVOLVE_EVENT_TO_CART)"
        setUrl(url: url)
        setParameters(parameters: makeDictionary(eventRequest))
        super.makeRequest(method: .POST)
    }
    func addProductToCart(request: ProductCartRequest){
           
           let url: String  = "\(ApiConstants.BASE_URL)\(CartApiConstants.ADD_PRODUCT_TO_CART)"
           setUrl(url: url)
           setParameters(parameters: makeDictionary(request))
           super.makeRequest(method: .POST)
       }
    
    func addArchieCardToCart(request: AddArchieCardToCartRequest){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(CartApiConstants.ADD_ARCHIE_CARD_TO_CART)"
        setUrl(url: url)
        setParameters(parameters: makeDictionary(request))
        super.makeRequest(method: .POST)
    }
    
    func addGiftCardToCart(request: AddGiftCardToCartRequest){
           
        let url: String  = "\(ApiConstants.BASE_URL)\(CartApiConstants.ADD_GIFT_CARD_TO_CART)"
           setUrl(url: url)
           setParameters(parameters: makeDictionary(request))
           super.makeRequest(method: .POST)
       }
       
    
    
    func removeFromCart(cartItem: CartItem){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(CartApiConstants.REMOVE_FROM_CART)"
        setUrl(url: url)
        setParameters(parameters: makeDictionary(CartRemoveRequest(cartItem: cartItem)))
        super.makeRequest(method: .POST)
    }
    
    
}
