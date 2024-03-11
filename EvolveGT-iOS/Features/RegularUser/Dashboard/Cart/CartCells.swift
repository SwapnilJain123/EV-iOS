//
//  CartCells.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 26/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

protocol CartCellDelegate {
    func deleteCartItem(cartItem: CartItem)
}
class BaseCartCell : UITableViewCell{
    
    @IBOutlet weak var imgOutOfStock: UIImageView!
    @IBOutlet weak var cartImage: UIImageView!
    @IBOutlet weak var cartTitle: UILabel!
    @IBOutlet weak var cartPrice: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    var cartItem : CartItem? = nil
    var delegate: CartCellDelegate? = nil
    
    func showData(){
        if  let url = URL(string : cartItem?.image?.toValidatedImageUrl() ?? ""){
            let fallbackImage = UIImage(named: "et_fallback_image")
            cartImage.kf.setImage(with: url,
                                  placeholder: fallbackImage,
                                  options: [.transition(ImageTransition.fade(1))])
            
        }
        imgOutOfStock.isHidden = !(cartItem?.isOutOfStock ?? false)
        cartTitle.text = cartItem?.title
        cartPrice.text = cartItem?.price?.formatToAmount(prefix: "Price: ")
        cartPrice.textColor = .getAppThemeColor()
        btnDelete.isHidden = !(cartItem?.canRemove ?? true)
        cartImage.superview?.setCardView()
        
        if !AppEngine.sharedInstance.isEvApp(){
            btnDelete.setImage(UIImage(named: "delete"), for: .normal)
        }else{
            btnDelete.setImage(UIImage(named: "moto_delete"), for: .normal)
        }
    }
    
    
    @IBAction func didPressDeletButton(_ sender: Any) {
        delegate?.deleteCartItem(cartItem: cartItem!)
    }
}
class CartAllPropertiesCell : BaseCartCell{
    static let identifier = "CartAllPropertiesCell"
    @IBOutlet weak var secondaryPropert: UILabel!
    @IBOutlet weak var tertiaryProperty: UILabel!
    
    override func showData() {
        super.showData()
        
        secondaryPropert.text = cartItem?.secondaryProperty
        tertiaryProperty.text = cartItem?.tertiaryProperty
    }
}

class Cart3PropertiesCell : BaseCartCell{
    static let identifier = "Cart3PropertiesCell"
    @IBOutlet weak var secondaryPropert: UILabel!
    override func showData() {
        super.showData()
        
        secondaryPropert.text = cartItem?.secondaryProperty
    }
}

class Cart2PropertiesCell : BaseCartCell{
    static let identifier = "Cart2PropertiesCell"
}
