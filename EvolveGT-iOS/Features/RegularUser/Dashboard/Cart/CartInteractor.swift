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
protocol PaymentDelegate{
    func didFinishTransaction(transactionID: String)
    func transactionError(message: String)
    func presentDropInPayment(token: String)
    func cartClearedError(message: String)
}
protocol CartReviewDelegate{
    func availableSections(sections: [CartReviewSections])
    func didChangeTotal()
    
}
enum CartReviewSections : Int{
    case summaryHeader
    case summaryItems
    case total
    case coupon
    case couponApplied
    case validBillingAddress
    case noBillingAddress
    case walletBalance
}
class CartInteractor: BaseInteractor{
    
    let ERROR_CART_CLEARED = 3
    var cartList = [CartItem]()
    var delegate: BaseViewDelegate? = nil
    
    var cartListDelegate : CartListDelegate? = nil
    var cartReviewDelegate: CartReviewDelegate? = nil
    var paymentDelegate: PaymentDelegate? = nil
    
    let coupon = Coupon()
    
    var subTotal: Double = 0
    var total: Double = 0
    var walletApplied: Double = 0
    var transactionId = ""
    var paymentMethod = PaymentMethod.paypal
    var nonce = ""
    
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
                    
                    if cartListResponse.cartList?.count ?? 0 > 0{
                        //move racefee to top
                        let regularItems = cartListResponse.cartList!.filter({$0.source != CartSource.racefee})
                        let raceFeeItems = cartListResponse.cartList!.filter({$0.source == CartSource.racefee})
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
                        
                        self.cartListDelegate?.didFetchCartList(cartItems: cartListResponse.cartList ?? [CartItem]())
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
    
    func computeCartReviewData(){
        getCartReviewSections()
        computeTotals()
    }
    func getCartReviewSections(){
        var sections = [CartReviewSections]()
        sections.append(.summaryHeader)
        sections.append(.summaryItems)
        sections.append(.total)
        
        if coupon.couponBalance > 0{
            sections.append(.couponApplied)
        }else{
            sections.append(.coupon)
        }
        
        
        if AppEngine.sharedInstance.userDetails?.billingAddress.isEmpty() ?? true{
            sections.append(.noBillingAddress)
        }else{
            sections.append(.validBillingAddress)
        }
        sections.append(.walletBalance)
        self.cartReviewDelegate?.availableSections(sections: sections)
    }
    
    func computeTotals() {
        subTotal = 0
        for cartItem in cartList{
            
            let qty = Double(cartItem.quantity ?? "1") ?? 1
            let price = Double(cartItem.price ?? "0") ?? 0
            let fee = Double(cartItem.feeAmount ?? "0") ?? 0
            subTotal += (qty * price) + fee
        }
        
        total = subTotal - coupon.couponBalance
        if total <= 0 {
            total = 0
            coupon.appliedCouponAmount = subTotal;
        }else {
            coupon.appliedCouponAmount = subTotal - total;
        }
        self.cartReviewDelegate?.didChangeTotal()
    }
    
    func deleteCoupon(){
        delegate?.showProgressIndicator(message: "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.coupon.couponCode = ""
            self.coupon.couponBalance = 0
            self.coupon.appliedCouponAmount = 0
            
            self.computeCartReviewData()
            self.delegate?.hideProgressIndicator()
        }
    }
    func validateCoupon(coupon: String){
        
        delegate?.showProgressIndicator(message: LoadingIndicatorMessages.validatingCoupon)
        let checkoutApi = CheckoutApi()
        checkoutApi.setCompletionHandler { (data, error) in
            self.delegate?.hideProgressIndicator()
            if error == nil{
                if let couponValidatedResponse = self.decodeFromJson(data!, modelType: CouponValidationResponse.self){
                    self.coupon.couponBalance = couponValidatedResponse.couponBalance?.toDouble() ?? self.coupon.couponBalance
                    self.computeTotals()
                    
                    if self.coupon.couponBalance > 0{
                        self.getCartReviewSections()
                    }
                }else{
                    self.delegate?.showErrorToastMessage(message: ErrorMessages.genericError)
                }
            }else{
                self.delegate?.showErrorToastMessage(message: error?.errorMessage ?? ErrorMessages.genericError)
            }
        }
        checkoutApi.validateCoupon(userId: AppEngine.sharedInstance.userID, couponCode: coupon)
    }
    
    private func getPaymentMode() -> PaymentMode{
        if total > 0.0{
            if paymentMethod == .wallet{
                if coupon.appliedCouponAmount > 0{
                    return .couponWallet
                }else{
                    return .wallet
                }
            }else{
                if coupon.appliedCouponAmount > 0{
                    return .couponPaypal
                }else{
                    return .paypal
                }
            }
            
        }else{
            if coupon.appliedCouponAmount > 0{
                return .coupon
            }else{
                return .wallet
            }
        }
    }
    func completeTransaction(){
        
        delegate?.showProgressIndicator(message: LoadingIndicatorMessages.placingOrder)
        
        let placeOrderRequest = PlaceOrderRequest()
        placeOrderRequest.coupon = coupon.couponCode
        placeOrderRequest.payment = getPaymentMode().rawValue
        placeOrderRequest.userId = AppEngine.sharedInstance.userID
        let checkoutApi = CheckoutApi()
        checkoutApi.setCompletionHandler{ data, error in
            
            if error == nil{
                if let response = self.decodeFromJson(data!, modelType: PlaceOrderResponse.self){
                    self.transactionId = response.transactionID ?? "0"
                    self.resetCartList()
                }else{
                    self.delegate?.showSuccessToastMessage(message: ErrorMessages.genericError)
                }
            }else{
                self.delegate?.hideProgressIndicator()
                self.delegate?.showSuccessToastMessage(message: error?.errorMessage ?? ErrorMessages.genericError)
            }
        }
        
        checkoutApi.placeOrder(placeOrderRequest: placeOrderRequest)
    }
    
    func resetCartList(){
        let checkoutApi = CheckoutApi()
        checkoutApi.setCompletionHandler{ data, error in
            self.delegate?.hideProgressIndicator()
            self.paymentDelegate?.didFinishTransaction(transactionID: self.transactionId)
        }
        checkoutApi.resetCartList(userId: AppEngine.sharedInstance.userID)
    }
    
    func paymentMethodChanged(method: PaymentMethod){
        self.paymentMethod = method
    }
    
    func isWalletPaymentAllowed() -> Bool{
        return AppEngine.sharedInstance.walletEnabled && AppEngine.sharedInstance.walletBalance > total
    }
    func getWalletBalance() -> Double{
        AppEngine.sharedInstance.walletBalance
    }
    func initiatePayment(){
        if paymentMethod == .wallet{
            completeTransaction()
        }else{
            
            self.delegate?.showProgressIndicator(message: LoadingIndicatorMessages.placingOrder)
            getBrainTreeToken()
        }
    }
    
    private func getBrainTreeToken(){
        let checkoutApi = CheckoutApi()
        checkoutApi.setCompletionHandler{ data, error in
            
            if error == nil{
                if let tokenResponse = self.decodeFromJson(data!, modelType: CheckoutTokenResponse.self){
                    self.delegate?.hideProgressIndicator()
                    self.paymentDelegate?.presentDropInPayment(token: tokenResponse.checkoutToken ?? "")
                }else{
                    self.delegate?.hideProgressIndicator()
                    self.paymentDelegate?.transactionError(message: ErrorMessages.genericError)
                }
            }else{
                self.delegate?.hideProgressIndicator()
                self.paymentDelegate?.transactionError(message: ErrorMessages.paypalTokenError)
            }
        }
        checkoutApi.getCheckoutToken(userId: AppEngine.sharedInstance.userID, email: AppEngine.sharedInstance.currentUser?.email ?? "")
    }
    func completeBrainTreeTransaction(nonce: String){
        self.delegate?.showProgressIndicator(message: LoadingIndicatorMessages.placingOrder)
        self.nonce = nonce
        let request = BrainTreeTransactionRequest()
        request.amount = String(total)
        request.brainTreeNonce = nonce
        request.coupon = coupon.couponCode
        request.mode = BuildScheme.paymentMode
        request.userId = AppEngine.sharedInstance.userID
        request.paymentType = getPaymentMode().rawValue
        
        let checkoutApi = CheckoutApi()
        checkoutApi.setCompletionHandler{ data, error in
            
            if error == nil{
                if let response = self.decodeFromJson(data!, modelType: BrainTreeTransactionResponse.self){
                    
                    if response.paymentStatus == 1{
                        self.transactionId = response.orderId ?? "0"
                        self.resetCartList()
                    }else{
                        
                        self.delegate?.hideProgressIndicator()
                        if response.cartStatus ?? 0 == self.ERROR_CART_CLEARED{
                            self.paymentDelegate?.cartClearedError(message: response.message ?? ErrorMessages.genericError)
                        }else{
                            self.paymentDelegate?.transactionError(message: response.message ?? ErrorMessages.genericError)
                        }
                        
                    }
                }else{
                    self.delegate?.hideProgressIndicator()
                    self.paymentDelegate?.transactionError(message: ErrorMessages.genericError)
                }
            }else{
                self.delegate?.hideProgressIndicator()
                self.paymentDelegate?.transactionError(message: error?.errorMessage ?? ErrorMessages.genericError)
            }
        }
        checkoutApi.completeBrainTreeTransaction(request: request)
    }
}
class Coupon{
    var couponCode = ""
    var couponBalance : Double = 0
    var appliedCouponAmount: Double = 0
}
enum PaymentMethod: Int{
    case paypal
    case wallet
}
