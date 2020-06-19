//
//  ReviewCartController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 27/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
class ReviewCartController : ETViewController{
    @IBOutlet weak var shippingIndicator: ShippingIndicator!
    @IBOutlet weak var btnPayment: UIButton!
    
    @IBOutlet weak var cartSummaryView: UITableView!
    var interactor : CartInteractor? = nil
    var cartItems : [CartItem]?
    var sections : [CartReviewSections]? = nil
    
    var hasOutOfStockItems = false
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_REVIEW_CART
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        btnPayment.applyColorTheme()
       
        DispatchQueue.main.async {
            self.sections?.removeAll()
            self.cartSummaryView.reloadData()
            self.interactor?.computeCartReviewData()
        }
       
        customizeShippingIndicator()
       
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
         btnPayment.applyColorTheme()
        cartSummaryView.dataSource = self
        interactor?.cartReviewDelegate = self
        interactor?.paymentDelegate = self
        
    }
    override func didChangeAppTheme() {
        interactor?.computeCartReviewData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.ext.showBackButton()
    }
    func customizeShippingIndicator(){
        shippingIndicator.leftCircleColor = .clear
        shippingIndicator.leftCircleBorderColor = .getAppThemeColor()
        shippingIndicator.middleCircleColor = .getInactiveGray()
        shippingIndicator.rightCircleColor = .getInactiveGray()
        
        shippingIndicator.leftLineColor = .getInactiveGray()
        shippingIndicator.rightLineColor = .getInactiveGray()
        shippingIndicator.indicatorViewBackground = UIColor(hexFromString: "#F5F6F7")
        
        
        if interactor?.total ?? 0 == 0{
            shippingIndicator.leftCircleColor = .getAppThemeColor()
            shippingIndicator.middleCircleBorderColor = .getAppThemeColor()
            shippingIndicator.leftLineColor = .getAppThemeColor()
        }else{
            shippingIndicator.leftCircleColor = .getInactiveGray()
                       shippingIndicator.middleCircleBorderColor = .getInactiveGray()
                       shippingIndicator.leftLineColor = .getInactiveGray()
        }
        shippingIndicator.redrawView()
    }
    
    @IBAction func didPressProceedToPayment(_ sender: Any) {
        
        if AppEngine.sharedInstance.userDetails?.billingAddress.isEmpty ?? true{
            self.ext.showAlert(title: "Checkout Error", message: "Please provide your billing address")
        }else if hasOutOfStockItems{
            self.ext.showAlert(title: "Cart Error", message: ErrorMessages.hasOutOfStockItems){
                self.navigationController?.popToRootViewController(animated: true)
            }
        }else{
            if interactor?.total ?? 0.0 > 0.0{
                let paymentVC = self.ext.getViewController(storyBoard: "Cart", VCIdentifier: "PaymentVC") as! PaymentViewController
                paymentVC.interactor = self.interactor
                self.ext.pushViewController(viewController: paymentVC)
            }else{
                interactor?.completeTransaction()
            }
        }
 
    }
}
extension ReviewCartController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sections?.count ?? 0 > 0{
            if sections![section] == CartReviewSections.summaryItems{
                return cartItems?.count ?? 0
            }else{
                return 1
            }
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections![indexPath.section] {
        case CartReviewSections.summaryHeader:
            let cell =  tableView.dequeueReusableCell(withIdentifier: CartReviewSummaryHeaderCell.identifier, for: indexPath) as! CartReviewSummaryHeaderCell
            cell.showData()
            return cell
            
        case CartReviewSections.summaryItems:
            let cell =  tableView.dequeueReusableCell(withIdentifier: CartReviewItemCell.identifier, for: indexPath) as! CartReviewItemCell
            cell.showData(cartItem : cartItems![indexPath.row])
            return cell
        case CartReviewSections.total:
            let cell =  tableView.dequeueReusableCell(withIdentifier: CartTotalCell.identifier, for: indexPath) as! CartTotalCell
            cell.showData(interactor!.subTotal, interactor!.total, interactor!.coupon.appliedCouponAmount)
            return cell
        case CartReviewSections.couponApplied:
            let cell =  tableView.dequeueReusableCell(withIdentifier: CartCouponAppliedCell.identifier, for: indexPath) as! CartCouponAppliedCell
            cell.showData(coupon: interactor!.coupon)
            cell.delegate = self
            return cell
        case CartReviewSections.coupon:
            let cell =  tableView.dequeueReusableCell(withIdentifier: CartPromoCodeCell.identifier, for: indexPath) as! CartPromoCodeCell
            cell.showData(coupon: interactor!.coupon)
            cell.delegate = self
            return cell
        case CartReviewSections.noBillingAddress, CartReviewSections.validBillingAddress:
                       let cell =  tableView.dequeueReusableCell(withIdentifier: BillingAddressCell.identifier, for: indexPath) as! BillingAddressCell
                       cell.showData(address: AppEngine.sharedInstance.userDetails?.billingAddress ?? "")
                       cell.delegate = self
                       return cell
        case CartReviewSections.walletBalance:
                       let cell =  tableView.dequeueReusableCell(withIdentifier: CartWalletCell.identifier, for: indexPath) as! CartWalletCell
                       cell.showData(walletBalanceAmount: AppEngine.sharedInstance.walletBalance)
                      
                       return cell
       
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections?.count ?? 0
    }
}
extension ReviewCartController: CouponCellDelegate, CartCouponAppliedCellDelegate, BillingAddressCellDelegate{
    func editBillingAddress() {
         let addressVC = self.ext.getViewController(storyBoard: "Address", VCIdentifier: "AddressVC") as! AddressViewController
                                  addressVC.hasAddress = true
                                  addressVC.addressType = .billing
                                  self.ext.pushViewController(viewController: addressVC)
        
    }
    
    func addBillingAddress() {
        let addressVC = self.ext.getViewController(storyBoard: "Address", VCIdentifier: "AddressVC") as! AddressViewController
        addressVC.hasAddress = false
        addressVC.addressType = .billing
        self.ext.pushViewController(viewController: addressVC)
    }
    
    func didRemoveCoupon() {
        interactor?.deleteCoupon()
    }
    
    func validateCoupon(coupon: String) {
        interactor?.validateCoupon(coupon: coupon)
    }
}
extension ReviewCartController : CartReviewDelegate, PaymentDelegate{
    func cartClearedError(message: String) {
         self.ext.showAlert(title: "Transaction Error", message: message)
    }
    
    func transactionError(message: String) {
        self.ext.showAlert(title: "Transaction Error", message: message)
    }
    
    func presentDropInPayment(token: String) {
        //Ignored
    }
    
    func didFinishTransaction(transactionID: String) {
        let postPurchaseVC = self.ext.getViewController(storyBoard: "Cart", VCIdentifier: "PostPurchase") as! PostPurchaseController
        postPurchaseVC.interactor = self.interactor
        self.ext.pushViewController(viewController: postPurchaseVC)
//        self.present(postPurchaseVC, animated: true){
//            self.navigationController?.popToRootViewController(animated: true)
//        }
        
    }
    
    func didChangeTotal() {
        let indexPath = IndexPath(row: 0, section: 2)
        cartSummaryView.reloadRows(at: [indexPath], with: .none)
        
        if interactor?.total ?? 0.0 > 0.0{
            btnPayment.setTitle("Proceed To Payment".uppercased(), for: .normal)
        }else{
             btnPayment.setTitle("Place Order".uppercased(), for: .normal)
        }
        
        self.customizeShippingIndicator()
    }
    
    func availableSections(sections: [CartReviewSections]) {
        self.sections = sections
        cartSummaryView.reloadData()
    }
}
