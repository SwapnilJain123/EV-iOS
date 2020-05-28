//
//  CartInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 26/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation

protocol CartListDelegate{
    func didFetchCartList(cartItems: [CartItem])
    func totalPrice(total: Double)
    func hasOutOfStockItems(outOfStock: Bool)
}
enum CartReviewSections : Int{
    case summaryHeader
    case summaryItems
    case total
    case coupon
    case validBillingAddress
    case noBillingAddress
    case walletBalance
}
class CartInteractor: BaseInteractor{
    
    var cartList = [CartItem]()
    var delegate: BaseViewDelegate? = nil
    var cartListDelegate : CartListDelegate? = nil
    let coupon = Coupon()
    
    func fetchCartList(){
        delegate?.showProgressIndicator(message: LoadingIndicatorMessages.loadingCartList)
        let checkoutApi = CheckoutApi()
        checkoutApi.setCompletionHandler{ data, error in
            
            self.delegate?.hideProgressIndicator()
            self.delegate?.hideEmptyPageError()
            if error == nil{
                if let cartListResponse = self.decodeFromJson(data!, modelType: CartListResponse.self){
                    AppEngine.sharedInstance.walletEnabled = cartListResponse.walletEnabled ?? 0 != 0
                    AppEngine.sharedInstance.walletBalance = cartListResponse.wallet?.toDouble() ?? 0
                    AppEngine.sharedInstance.cartListCount = cartListResponse.cartList?.count ?? 0
                    
                    if let cartItems = cartListResponse.cartList{
                        //move racefee to top
                        let regularItems = cartItems.filter({$0.source != CartSource.racefee})
                        let raceFeeItems = cartItems.filter({$0.source == CartSource.racefee})
                        var finalResults = [CartItem]()
                        finalResults.append(contentsOf: raceFeeItems)
                        finalResults.append(contentsOf: regularItems)
                        self.cartListDelegate?.didFetchCartList(cartItems: finalResults)
                        
                        var total: Double = 0
                        var hasOutOfStock = false
                        for item in finalResults{
                            total = total + ((item.quantity?.toDouble() ?? 1) * (item.price?.toDouble() ?? 0))
                            
                            if item.isOutOfStock{
                                hasOutOfStock = true
                            }
                        }
                        self.cartList = finalResults
                        self.cartListDelegate?.hasOutOfStockItems(outOfStock: hasOutOfStock)
                        self.cartListDelegate?.totalPrice(total: total)
                    }else{
                        self.delegate?.showEmptyPageError(message: ErrorMessages.emptyCartList)
                    }
                    
                }else{
                    self.delegate?.showEmptyPageError(message: ErrorMessages.genericError)
                }
            }else{
                self.delegate?.showEmptyPageError(message: error?.errorMessage ?? ErrorMessages.genericError)
            }
        }
        checkoutApi.fetchCartList(userId: AppEngine.sharedInstance.userID)
    }
    
    func removeFromCart(cartItem: CartItem){
        delegate?.showProgressIndicator(message: LoadingIndicatorMessages.deletingCartItem)
        let cartApi = CartApi()
        cartApi.setCompletionHandler { (data, error) in
            self.delegate?.hideProgressIndicator()
            if error == nil{
                self.delegate?.showSuccessToastMessage(message: SuccessMessages.cartItemDeleted)
                self.fetchCartList()
            }else{
                self.delegate?.showErrorToastMessage(message: error?.errorMessage ?? ErrorMessages.genericError)
            }
        }
        cartApi.removeFromCart(cartItem: cartItem)
    }
    
    func getCartReviewSections() -> [CartReviewSections]{
        var sections = [CartReviewSections]()
        sections.append(.summaryHeader)
        sections.append(.summaryItems)
        sections.append(.total)
        sections.append(.coupon)
        
        if AppEngine.sharedInstance.userDetails?.billingAddress.isEmpty() ?? true{
            sections.append(.noBillingAddress)
        }else{
            sections.append(.validBillingAddress)
        }
        sections.append(.walletBalance)
        return sections
    }
    
    func computeTotals() -> (subTotal: Double, total: Double){
        var subTotal: Double = 0
        for cartItem in cartList{
            
            let qty = Double(cartItem.quantity ?? "1") ?? 1
            let price = Double(cartItem.price ?? "0") ?? 0
            let fee = Double(cartItem.feeAmount ?? "0") ?? 0
            subTotal += (qty * price) + fee
        }
        
        var total = subTotal - coupon.couponBalance
        if total <= 0 {
            total = 0
            coupon.appliedCouponAmount = subTotal;
        }else {
            coupon.appliedCouponAmount = subTotal - total;
        }
        return (subTotal,total)
    }
}
class Coupon{
    var couponCode = ""
    var couponBalance : Double = 0
    var appliedCouponAmount: Double = 0
}
