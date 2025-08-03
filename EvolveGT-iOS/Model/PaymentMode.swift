//
//  PaymentMode.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 31/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
enum PaymentMode : String{
    case wallet
    case paypal
    case coupon
    case walletPaypal = "wallet-paypal"
    case couponWallet = "coupon-wallet"
    case couponWalletPaypal = "coupon-wallet-paypal"
    case couponPaypal = "coupon-paypal"
}
