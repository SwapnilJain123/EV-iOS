//
//  ProductDetailsCells.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 24/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher


class ProductInfoCell : UITableViewCell{
    
    @IBOutlet weak var productLogo: UIImageView!
    @IBOutlet weak var productName: UILabel!

    @IBOutlet weak var productPrice: UILabel!
    
    func showData(productDetails : ProductDetails){
        
        if  let url = URL(string : productDetails.image?.toValidatedImageUrl() ?? ""){
                   let fallbackImage = UIImage(named: "et_fallback_image")
                   productLogo.kf.setImage(with: url,
                                          placeholder: fallbackImage,
                                          options: [.transition(ImageTransition.fade(1))])
                   
               }
               productName.text! = productDetails.title ?? ""
        productPrice.text = "Price : \(productDetails.productVariantPrice.formatToAmount())"
        productPrice.textColor = .getAppThemeColor()
    }
}

class ProductQuantityCell : UITableViewCell{
    static let identifier = "ProductQuantityCell"
    
    
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var btnPlus: UIButton!
    
    @IBOutlet weak var buttonMinus: UIButton!
    @IBOutlet weak var labelTotal: UILabel!
    
    @IBOutlet weak var labelQuantity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        buttonMinus.applyMinusButtonTheme()
        btnPlus.applyPlusButtonTheme()
    }
    
    var productDetails: ProductDetails? = nil
    func showData(productDetails: ProductDetails){
        
        self.productDetails = productDetails
        
        labelQuantity.text = String(productDetails.quantity)
        let total = Double(productDetails.quantity) * (productDetails.productVariantPrice.toDouble())
        
        labelTotal.text = "Total: \(String(total).formatToAmount())"
        
        rootView.setCardView()
    }
    
    
    @IBAction func didPressPlusButton(_ sender: UIButton) {
        self.productDetails?.quantity += 1
        showData(productDetails: productDetails!)
    }
    
    @IBAction func didPressMinusButton(_ sender: Any) {
        if self.productDetails?.quantity ?? 1 > 0{
            self.productDetails?.quantity -= 1
        }
        showData(productDetails: productDetails!)
    }
    
}
class ProductOutOfStockCell : UITableViewCell{
    static let identifier = "ProductOutOfStockCell"
}

protocol ProductVariantsCellDelegate{
    func didChangeVariantSelection(indexPath: IndexPath)
}
class ProductVariantsCell : UITableViewCell{
    static let identifier = "ProductVariantsCell"
    
    var delegate : ProductVariantsCellDelegate? = nil
  
    @IBOutlet weak var attributeDropDown: DropDownList!
    @IBOutlet weak var variantTitle: UILabel!
    
    var productVariation : ProductVariation? = nil
    var indexPath: IndexPath? = nil
    
    public func showData(productVariation : ProductVariation, indexPath: IndexPath){
        self.productVariation = productVariation
        self.indexPath = indexPath
        
        attributeDropDown.borderColor = .getAppThemeColor()
        attributeDropDown.arrowColor = .getAppThemeColor()
        variantTitle.text = "Select \(productVariation.variantName ?? "")"
        attributeDropDown.text = productVariation.selectedVariant.value
        attributeDropDown.optionArray = productVariation.options
        attributeDropDown.selectedRowColor = .getLightBackgroundColor()
        attributeDropDown.checkMarkEnabled = false
        attributeDropDown.selectedIndex = self.productVariation!.variants!.firstIndex(where: {$0.value == self.productVariation?.selectedVariant.value})
        attributeDropDown.didSelect{(selectedText , index ,id) in
            self.productVariation!.selectedVariant = self.productVariation!.variants![index]
            self.delegate?.didChangeVariantSelection(indexPath: self.indexPath!)
        }
    }
    
    @IBAction func didPressDropDown(_ sender: Any) {
        self.attributeDropDown.showList()
    }
}
