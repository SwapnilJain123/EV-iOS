//
//  CartReviewCells.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 28/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
class CartReviewItemCell : UITableViewCell{
    static let identifier = "CartReviewItemCell"
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemAttributes: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    
    func showData(cartItem: CartItem){
        itemTitle.text = cartItem.title
        itemAttributes.text = cartItem.priceInfoText
        itemPrice.text = String(cartItem.totalPrice).formatToAmount(prefix: "Total: ")
        itemPrice.textColor = .getAppThemeColor()
    }
}
class CartTotalCell : UITableViewCell{
    @IBOutlet weak var subTotalLabel: UILabel!
    static let identifier = "CartTotalCell"
    @IBOutlet weak var totalLabel: UILabel!
    
    func showData(_ subtotal: Double, _ total: Double){
        subTotalLabel.text = String(subtotal).formatToAmount()
        totalLabel.text = String(total).formatToAmount()
        
        totalLabel.textColor = .getAppThemeColor()
         subTotalLabel.textColor = .getAppThemeColor()
    }
}
class CartPromoCodeCell : UITableViewCell{
    static let identifier = "CartPromoCodeCell"
}
