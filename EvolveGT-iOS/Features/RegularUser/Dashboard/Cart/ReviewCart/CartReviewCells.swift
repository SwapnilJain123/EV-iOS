//
//  CartReviewCells.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 28/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

class CartReviewSummaryHeaderCell : UITableViewCell{
    static let identifier = "CartReviewSummaryHeaderCell"
    
    func showData(){
        styleDividers()
    }
}
class CartReviewItemCell : UITableViewCell{
    static let identifier = "CartReviewItemCell"
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemAttributes: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    
    @IBOutlet weak var labelOutOfStock: UILabel!
    func showData(cartItem: CartItem){
        itemTitle.text = cartItem.title
        itemAttributes.text = cartItem.priceInfoText
        itemPrice.text = String(cartItem.totalPrice).formatToAmount(prefix: "Total: ")
        itemPrice.textColor = .getAppThemeColor()
        labelOutOfStock.isHidden = !cartItem.isOutOfStock
       styleDividers()
    }
}
class CartTotalCell : UITableViewCell{
    @IBOutlet weak var subTotalLabel: UILabel!
    static let identifier = "CartTotalCell"
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var discountApplied: UILabel!
    func showData(_ subtotal: Double, _ total: Double, _ discount : Double){
        subTotalLabel.text = String(subtotal).formatToAmount()
        totalLabel.text = String(total).formatToAmount()
        discountApplied.text = String(discount).formatToAmount()
        
        totalLabel.textColor = .getAppThemeColor()
        discountApplied.textColor = .getAppThemeColor()
        subTotalLabel.textColor = .getAppThemeColor()
        
        styleDividers()
    }
}

protocol CouponCellDelegate{
    func validateCoupon(coupon: String)
}
class CartPromoCodeCell : UITableViewCell, UITextFieldDelegate{
    static let identifier = "CartPromoCodeCell"
    
    @IBOutlet weak var btnApply: UIButton!
    var coupon : Coupon = Coupon()
    var delegate: CouponCellDelegate? = nil
    @IBOutlet weak var tfCouponCode: SkyFloatingLabelTextField!
    
    @IBAction func didPressApplyButton(_ sender: Any) {
        coupon.couponCode = tfCouponCode.text ?? ""
        if coupon.couponCode.isEmpty{
            tfCouponCode.errorMessage = ErrorMessages.invalidCoupon
            return
        }
        delegate?.validateCoupon(coupon: coupon.couponCode)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        tfCouponCode.delegate = self
        tfCouponCode.placeholder = "Coupon Code"
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tfCouponCode.errorMessage = ""
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.coupon.couponCode = textField.text ?? ""
    }
    func showData(coupon: Coupon){
        self.coupon = coupon
        tfCouponCode.text = coupon.couponCode
        
        if BuildScheme.isBuildQA{
            self.tfCouponCode.text = ""//FW9L-GHLT-US18"
        }
        btnApply.applyBoarderColorTheme()
        tfCouponCode.applyColorTheme()
    }
}

protocol CartCouponAppliedCellDelegate{
    func didRemoveCoupon()
}
class CartCouponAppliedCell : UITableViewCell{
    static let identifier = "CartCouponAppliedCell"
    
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var labelCouponCode: UILabel!
    @IBOutlet weak var lbelCouponBalance: UILabel!
    
    var delegate: CartCouponAppliedCellDelegate? = nil
    @IBAction func didPressDeleteButton(_ sender: UIButton) {
        self.delegate?.didRemoveCoupon()
    }
   
    func showData(coupon: Coupon){
        
        labelCouponCode.text = "Coupon Code: \(coupon.couponCode)"
        
        lbelCouponBalance.text = "Coupon Balance: \(String(coupon.couponBalance).formatToAmount())"
        if AppEngine.sharedInstance.isEvApp(){
            
            btnDelete.setImage(UIImage(named: "delete"), for: .normal)
        }else{
            btnDelete.setImage(UIImage(named: "moto_delete"), for: .normal)
        }
    }
}

protocol BillingAddressCellDelegate{
    func editBillingAddress()
    func addBillingAddress()
}
class BillingAddressCell : UITableViewCell{
    static let identifier = "BillingAddressCell"
    
    var delegate: BillingAddressCellDelegate? = nil
    
    @IBOutlet weak var btnAddressAction: UIButton!
    @IBOutlet weak var labelAddress: UILabel!
    
    var address = ""
    func showData(address : String){
        self.address = address
        if address.isEmpty(){
            btnAddressAction.applyPlusButtonTheme()
            labelAddress.text = ErrorMessages.checkoutNoBillingAddress
        }else{
             btnAddressAction.applyEditButtonTheme()
            labelAddress.text = address
        }
    }
    
    @IBAction func didPressAddressAction(_ sender: UIButton) {
        
        if address.isEmpty(){
            delegate?.addBillingAddress()
        }else{
            delegate?.editBillingAddress()
        }
    }
}
class CartWalletCell : UITableViewCell{
    static let identifier = "CartWalletCell"
    
    
    @IBOutlet weak var walletAmount: UILabel!
    
    func showData(walletBalanceAmount : Double){
        walletAmount.textColor = .getAppThemeColor()
        walletAmount.text = String(walletBalanceAmount).formatToAmount()
    }
}
