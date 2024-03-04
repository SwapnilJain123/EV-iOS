//
//  BaseInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class BaseInteractor{
    
     var delegate : BaseViewDelegate?
    
    enum FilterType {
        case trainingType
        case month
        case eventType
        case none
    }
    
    func decodeFromJson<T: Decodable>(_ data: Data, modelType: T.Type) -> T? {
           
        var decoded : T?
        let decoder = JSONDecoder()
        do{
             decoded = try decoder.decode(modelType, from: data)
        }catch let DecodingError.typeMismatch(type, context)  {
            Log.e("Type '\(type)' mismatch: \(context.debugDescription)")
            Log.e("codingPath: \(context.codingPath)")
            
        }catch let DecodingError.keyNotFound(key, context)  {
            Log.e("Key '\(key)' mismatch: \(context.debugDescription)")
            Log.e("codingPath: \(context.codingPath)")
            
        }catch{
            Log.e("Json Decode error")
        }
    
        return decoded
    }
    
    func viewDidLoad(){
        
    }
    
    func syncCartBadgeCount(){
           let checkoutApi = CheckoutApi()
           checkoutApi.setCompletionHandler{ data, error in
              
               if error == nil{
                   if let cartListResponse = self.decodeFromJson(data!, modelType: CartListResponse.self){
                       
                       AppEngine.sharedInstance.cartListCount = cartListResponse.cartList?.count ?? AppEngine.sharedInstance.cartListCount
                       
                       self.delegate?.updateCartBadge(count: AppEngine.sharedInstance.cartListCount )
                       
                    AppEngine.sharedInstance.walletBalance = cartListResponse.wallet?.toDouble() ?? AppEngine.sharedInstance.walletBalance
                   }else{
                       Log.e("Could not sync the Cart Badge")
                   }
                
                self.cartListUpdated()
               }else{
                   Log.e("Could not sync the Cart Badge")
                self.cartSyncError()
               }
           }
           checkoutApi.fetchCartList(userId: AppEngine.sharedInstance.userID)
       }
    
    
    func cartListUpdated(){
        
    }
    
    func cartSyncError(){
        
    }
}
