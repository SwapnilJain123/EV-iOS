//
//  ShopsApi.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class ShopsApi : BaseApiAdapter{
    
    func fetchCategoryList(){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(ShopsApiConstants.PRODUCT_CATEGORY_LIST)"
        setUrl(url: url)
        super.makeRequest(method: .POST)
    }
    
    func fetchProductList(category: ProductCategory, source: String){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(ShopsApiConstants.PRODUCT_LIST)"
        let request = ProductListRequest(productCategory: category, source: source)
        setParameters(parameters: makeDictionary(request))
        setUrl(url: url)
        super.makeRequest(method: .POST)
    }
    
    func fetchProductDetails(slug: String){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(ShopsApiConstants.PRODUCT_DETAILS)"
        let request = ItemDetailRequest(slug: slug)
        setParameters(parameters: makeDictionary(request))
        setUrl(url: url)
        super.makeRequest(method: .POST)
    }
    
    //Mark:- Archie Cards
    func fetchArchieCardList(){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(ShopsApiConstants.ARCHIE_CARD_LIST)"
        setUrl(url: url)
        super.makeRequest(method: .GET)
    }
    
    
    func fetchArchieCardDetails(slug:String){
        
        let request = ItemDetailRequest(slug: slug)
        setParameters(parameters: makeDictionary(request))
        
        let url: String  = "\(ApiConstants.BASE_URL)\(ShopsApiConstants.ARCHIE_CARD_DETAILS)"
        setUrl(url: url)
        super.makeRequest(method: .POST)
    }
    //GiftCard
    func fetchGiftCardList(){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(ShopsApiConstants.GIFT_CARD_LIST)"
        setUrl(url: url)
        super.makeRequest(method: .GET)
    }
    func fetchMembershipList(){
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.MEMBERSHIP_LIST)"
        setUrl(url: url)
        super.makeRequest(method: .GET)
    }
    
    func fetchGiftCardDetails(slug:String){
        
        let request = ItemDetailRequest(slug: slug)
        setParameters(parameters: makeDictionary(request))
        
        let url: String  = "\(ApiConstants.BASE_URL)\(ShopsApiConstants.GIFT_CARD_DETAILS)"
        setUrl(url: url)
        super.makeRequest(method: .POST)
    }
    
    
    func fetchMembershipDetails(slug:String){
        
        //let request = ItemDetailRequest(slug: slug)
        var request = ItemDetailRequest()
        request.slug = slug
        
        setParameters(parameters: makeDictionary(request))
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.MEMBERSHIP_DETAILS)"
        setUrl(url: url)
        super.makeRequest(method: .POST)
    }
    
    func fetchMRLMembershipMessage(){
        
        let url: String  = "\(ApiConstants.BASE_URL)\(UserApiConstants.MRL_MESSAGE)"
        setUrl(url: url)
        super.makeRequest(method: .GET)
    }
}
