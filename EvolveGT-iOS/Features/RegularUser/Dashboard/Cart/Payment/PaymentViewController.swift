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
import SnapKit
import WebKit

class PaymentViewController : ETViewController, CartListDelegate{
    
    @IBOutlet weak var walletBalance: UILabel!
    @IBOutlet weak var btnReview: UIButton!
    @IBOutlet weak var btnPlaceOrder: UIButton!
    
    @IBOutlet weak var shippingIndicator: ShippingIndicator!
    
    @IBOutlet weak var radioButtonGroup: RadioButtonContainerView!
    @IBOutlet weak var labelsubTotal: UILabel!
    @IBOutlet weak var labelCouponApplied: UILabel!
    
    @IBOutlet weak var labelTotal: UILabel!
    
    @IBOutlet weak var btnPaypal: RadioButton!
    
    @IBOutlet weak var btnWallet: RadioButton!
    
    @IBOutlet weak var labelCoupon: UILabel!
    
    @IBOutlet weak var labelWalletApplied: UILabel!
    
    @IBOutlet weak var labelWalletText: UILabel!
    @IBOutlet weak var webviewForPayment: WKWebView!
    @IBOutlet weak var labelTotalPaymentForWebView: UILabel!
    @IBOutlet weak var cbAcceptTermsAndConditions: CheckboxButton!

    var interactor: CartInteractor?
    var webView: WKWebView!
    var paymentMethod = PaymentMethod.paypal
    let coupon = Coupon()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.ext.showBackButton()
        }
        
        //        interactor?.paymentDelegate = self
        radioButtonGroup.buttonContainer.delegate = self
        
        self.webviewForPayment.superview?.frame = self.view.bounds
        self.view.addSubview(self.webviewForPayment.superview ?? view)
        self.webviewForPayment.superview?.isHidden = true
        
        cbAcceptTermsAndConditions.delegate = self
        cbAcceptTermsAndConditions.applyCheckboxTheme()
    }
    
    func didFetchCartList(cartItems: [CartItem]) {
    }
    
    func totalPrice(total: Double) {
        Log.d("New Total : \(total)")
        populateUi()
    }
    
    func hasOutOfStockItems(outOfStock: Bool) {
        
    }

    func populateUi(){
        let dueAmount = interactor?.computeFinalPayment()
        
        labelsubTotal.text = String(interactor?.subTotal ?? 0).formatToAmount()
        
        
        labelTotal.text = String(dueAmount ?? 0).formatToAmount()
        labelTotalPaymentForWebView.text = String(dueAmount ?? 0).formatToAmount()
        
        btnWallet.isEnabled = interactor?.isWalletPaymentAllowed() ?? true
        
        labelCouponApplied.text = String(interactor?.coupon.appliedCouponAmount ?? 0).formatToAmount()
        
        labelWalletApplied.text = String(interactor?.walletApplied ?? 0).formatToAmount()
        if interactor?.walletApplied ?? 0 > 0{
            
            walletBalance.text = ""
        }else{
            walletBalance.text = "Your Wallet Balance: \(String(interactor?.getWalletBalance() ?? 0).formatToAmount())"
        }
        btnPaypal.isOn = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnPlaceOrder.applyColorTheme()
        btnPlaceOrder.isEnabled = false
        
        labelsubTotal.textColor = .getAppThemeColor()
        labelTotal.textColor = .getAppThemeColor()
        //        customizeShippingIndicator()
        btnReview.applyBoarderColorTheme()
        btnPaypal.applyRadioButtonTheme()
        btnWallet.applyRadioButtonTheme()
        
        populateUi()
        interactor?.cartListDelegate = self
        self.ext.showNavbar()
        self.ext.showBackButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.100, execute: {
            self.interactor?.fetchCartList()
        })
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
    
    @IBAction func didPressDonePayment(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: false)
    }

    @IBAction func didPressPlaceOrder(_ sender: Any) {
        
        if paymentMethod == .wallet {
            interactor?.initiatePayment()
        } else {
            self.webviewForPayment.superview?.isHidden = false
            self.webviewForPayment.uiDelegate = self
            self.webviewForPayment.navigationDelegate = self
            let userId = AppEngine.sharedInstance.userID
            if let paymentMode = interactor?.getPaymentMode() {
                let urlString = "\(ApiConstants.BASE_URLPaypal)paypal.php?user_id=\(userId)&payment_modes=\(paymentMode)&coupon=\(coupon.couponCode)&device=iOS"
                if let url = URL(string: urlString) {
                    self.webviewForPayment.load(URLRequest.init(url: url))
                }
            }
        }
    }
    
    @IBAction func didPressCancellationPolicy(_ sender: Any) {
        let vc = self.ext.getViewController(storyBoard: "Settings", VCIdentifier:"TermsAndConditionViewController") as! TermsAndConditionViewController
        vc.url = CheckoutApiConstants.CANCELLATIONPOLICY
        vc.screenTitle = ScreenTitle.TITLE_CANCELLATIONPOLICY
        self.ext.pushViewController(viewController: vc)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.popToRootViewController(animated: false)
    }
}
extension PaymentViewController{
    func cartClearedError(message: String) {
        self.ext.showAlert(title: "Transaction Error", message: message){
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func transactionError(message: String) {
        self.ext.showAlert(title: "Transaction Error", message: message)
    }
    
    //    func presentDropInPayment(token: String) {
    //        let request =  BTDropInRequest()
    //        let dropIn = BTDropInController(authorization: token, request: request)
    //        { (controller, result, error) in
    //            if (error != nil) {
    //                Log.e("ERROR")
    ////            } else if (result?.isCanceled == true) {
    ////                 Log.e("CANCELLED")
    //            } else if let paymentResult = result {
    //                let nonce : String = paymentResult.paymentMethod?.nonce ?? ""
    //                self.interactor?.completeBrainTreeTransaction(nonce: nonce)
    //            }
    //            controller.dismiss(animated: true, completion: nil)
    //        }
    //        self.present(dropIn!, animated: true, completion: nil)
    //    }
    
    func didFinishTransaction(transactionID: Int) {
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
            paymentMethod = .wallet
        }else if button == btnPaypal{
            interactor?.paymentMethodChanged(method: .paypal)
            paymentMethod = .paypal
            
        }else{
            Log.e("Payment Method not defined")
        }
    }
    
    func radioButtonDidDeselect(_ button: RadioButton) {
        
    }
}

extension PaymentViewController: UIWebViewDelegate, WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("start loading")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: ((WKNavigationActionPolicy) -> Void)) {
        print(webView.url?.absoluteString)
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print(webView.url?.absoluteString)
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            UIApplication.shared.open(navigationAction.request.url!)
        }
        return nil
    }
}

extension PaymentViewController : CheckboxButtonDelegate{
    func chechboxButtonDidSelect(_ button: CheckboxButton) {
        btnPlaceOrder.isEnabled = true
    }
    
    func chechboxButtonDidDeselect(_ button: CheckboxButton) {
        btnPlaceOrder.isEnabled = false
    }
}
