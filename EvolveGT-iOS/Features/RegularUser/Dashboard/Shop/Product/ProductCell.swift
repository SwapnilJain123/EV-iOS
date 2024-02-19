//
//  ProductCell.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
class ProductCell: UICollectionViewCell{
    
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var productLogo: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    
    var product : Product?{
        didSet{
            updateViews()
        }
    }
    
    private func updateViews(){
        if  let url = URL(string : product?.image?.toValidatedImageUrl() ?? ""){
            let fallbackImage = UIImage(named: "et_fallback_image")
            productLogo.kf.setImage(with: url,
                                   placeholder: fallbackImage,
                                   options: [.transition(ImageTransition.fade(1))])
            
        }
        productLabel.text! = product?.title ?? ""
        rootView.setCardView()
    }
}
