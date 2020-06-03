//
//  PaymentViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 31/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import MBRadioCheckboxButton
import BraintreeDropIn
import Braintree

class PaymentViewController : ETViewController{
    
    @IBOutlet weak var walletBalance: UILabel!
    @IBOutlet weak var btnReview: UIButton!
    @IBOutlet weak var btnPlaceOrder: UIButton!
    
    @IBOutlet weak var shippingIndicator: ShippingIndicator!
    
    @IBOutlet weak var radioButtonGroup: RadioButtonContainerView!
    @IBOutlet weak var labelsubTotal: UILabel!
    @IBOutlet weak var labelCouponApplied: UILabel!
    @IBOutlet weak var labelWalletApplied: UILabel!
    @IBOutlet weak var labelTotal: UILabel!
    
    @IBOutlet weak var btnPaypal: RadioButton!
    
    @IBOutlet weak var btnWallet: RadioButton!
    
    var interactor: CartInteractor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.ext.showBackButton()
        }
         
        interactor?.paymentDelegate = self
        
        radioButtonGroup.buttonContainer.delegate = self
        labelsubTotal.text = String(interactor?.subTotal ?? 0).formatToAmount()
        labelCouponApplied.text = String(interactor?.coupon.appliedCouponAmount ?? 0).formatToAmount()
        labelWalletApplied.text = String(interactor?.walletApplied ?? 0).formatToAmount()
        labelTotal.text = String(interactor?.total ?? 0).formatToAmount()
        
        btnWallet.isEnabled = interactor?.isWalletPaymentAllowed() ?? true
        walletBalance.text = "Your Wallet Balance: \(String(interactor?.getWalletBalance() ?? 0).formatToAmount())"
        btnPaypal.isOn = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnPlaceOrder.applyColorTheme()
        
        labelsubTotal.textColor = .getAppThemeColor()
        labelTotal.textColor = .getAppThemeColor()
        customizeShippingIndicator()
        btnReview.applyBoarderColorTheme()
        btnPaypal.applyRadioButtonTheme()
        btnWallet.applyRadioButtonTheme()
    }
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_CART_PAYMENT
    }
    func customizeShippingIndicator(){
        let appColor = UIColor.getAppThemeColor()
        shippingIndicator.leftCircleColor = appColor
        shippingIndicator.leftCircleBorderColor = appColor
        shippingIndicator.middleCircleColor = .getInactiveGray()
        shippingIndicator.middleCircleBorderColor = appColor
        
        shippingIndicator.rightCircleColor = .getInactiveGray()
        
        shippingIndicator.leftLineColor = appColor
        shippingIndicator.rightLineColor = .getInactiveGray()
        shippingIndicator.indicatorViewBackground = UIColor(hexFromString: "#F5F6F7")
        shippingIndicator.redrawView()
    }
    
    
    @IBAction func didPressReviewButton(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func didPressPlaceOrder(_ sender: Any) {
        interactor?.initiatePayment()
    }
    
}
extension PaymentViewController: PaymentDelegate{
    func cartClearedError(message: String) {
        self.ext.showAlert(title: "Transaction Error", message: message){
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func transactionError(message: String) {
        self.ext.showAlert(title: "Transaction Error", message: message)
    }
    
    func presentDropInPayment(token: String) {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: token, request: request)
        { (controller, result, error) in
            if (error != nil) {
                Log.e("ERROR")
            } else if (result?.isCancelled == true) {
                 Log.e("CANCELLED")
            } else if let paymentResult = result {
                let nonce : String = paymentResult.paymentMethod?.nonce ?? ""
                self.interactor?.completeBrainTreeTransaction(nonce: nonce)
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }
    
    func didFinishTransaction(transactionID: String) {
        let postPurchaseVC = self.ext.getViewController(storyBoard: "Cart", VCIdentifier: "PostPurchase") as! PostPurchaseController
         postPurchaseVC.interactor = self.interactor
         self.ext.pushViewController(viewController: postPurchaseVC)
       // self.present(postPurchaseVC, animated: true){
        //    self.navigationController?.popToRootViewController(animated: true)
      //  }
    }
}
extension PaymentViewController :RadioButtonDelegate{
    func radioButtonDidSelect(_ button: RadioButton) {
        if button == btnWallet{
            interactor?.paymentMethodChanged(method: .wallet)
        }else if button == btnPaypal{
            interactor?.paymentMethodChanged(method: .paypal)
        }else{
            Log.e("Payment Method not defined")
        }
    }
    
    func radioButtonDidDeselect(_ button: RadioButton) {
        
    }
    
    
}
