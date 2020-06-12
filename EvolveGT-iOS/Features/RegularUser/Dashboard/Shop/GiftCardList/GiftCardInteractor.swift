//
//  GiftCardInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 01/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
protocol GiftCardListDelegate {
    func didFetchGiftCardList(giftCardList:[GiftCard])
}

protocol GiftCardDetailsDelegate {
    func didFetchGiftCardDetails(giftCardDetails:GiftCardDetails)}


class GiftCardInteractor:BaseInteractor{
    
    var viewDelegate : BaseViewDelegate?
    var giftCardListDelegate: GiftCardListDelegate?
    var giftCardDetailsDelegate: GiftCardDetailsDelegate?
    
    func getGiftCardList(){
        
        viewDelegate?.showProgressIndicator(message: LoadingIndicatorMessages.loadingGiftCardList)
        
        
        let giftCardApi = ShopsApi()
        giftCardApi.setCompletionHandler(){data,error in
            
            self.viewDelegate?.hideProgressIndicator()
            
            if error == nil {
                if let giftCardListResponse = self.decodeFromJson(data!, modelType: GiftCardListResponse.self){
                    
                    if giftCardListResponse.giftCardList?.count == 0{
                        
                        self.viewDelegate?.showEmptyPageError(message: ErrorMessages.emptyGiftCards)
                    }else{
                        self.giftCardListDelegate?.didFetchGiftCardList(giftCardList: giftCardListResponse.giftCardList!)
                    }
                }else{
                    self.viewDelegate?.showEmptyPageError(message: ErrorMessages.genericError)
                }
                
                
            }else{
                self.viewDelegate?.showEmptyPageError(message: error?.errorMessage ?? ErrorMessages.genericError)
            }
        }
        
        giftCardApi.fetchGiftCardList()
        
    }
    
    func getGiftCardDetails(slug:String){
        
        self.viewDelegate?.showProgressIndicator(message: LoadingIndicatorMessages.loadingGiftCardDetails)
        
        let giftCardApi = ShopsApi()
        giftCardApi.setCompletionHandler{data , error in
            
            self.viewDelegate?.hideProgressIndicator()
            
            if error == nil{
                let giftCardDetailsResponse = self.decodeFromJson(data!, modelType: GiftCardDetailsResponse.self)
                
                self.giftCardDetailsDelegate?.didFetchGiftCardDetails(giftCardDetails: (giftCardDetailsResponse?.giftCardDetails)!)
                
            }else{
                
                self.viewDelegate?.showEmptyPageError(message: error?.errorMessage ?? ErrorMessages.genericError)
                
            }
            
        }
        
        giftCardApi.fetchGiftCardDetails(slug: slug)
        
        
        
    }
    
    func addGiftCardToCart(name:String ,email:String , giftCardDetails:GiftCardDetails) {
        
        self.viewDelegate?.showProgressIndicator(message: LoadingIndicatorMessages.addingGiftCardToCart)
        
        var request = AddGiftCardToCartRequest()
        request.email = email
        request.name = name
        request.image = giftCardDetails.image
        request.price = giftCardDetails.price
        request.title = giftCardDetails.title
        request.slug = giftCardDetails.slug
        request.serial = AppEngine.sharedInstance.userID
        request.quantity = "1"
        
       let cartApi = CartApi()
        cartApi.setCompletionHandler{ data,error in
            
            self.viewDelegate?.hideProgressIndicator()
            
            if error == nil{
                
                self.viewDelegate?.showSuccessToastMessage(message: SuccessMessages.giftCardtAddedToCart)
                
            }else{
                
               self.viewDelegate?.showErrorToastMessage(message: error?.errorMessage ?? ErrorMessages.genericError)
                
            }
            
        }
        
        cartApi.addGiftCardToCart(request: request)
        
    }
}





