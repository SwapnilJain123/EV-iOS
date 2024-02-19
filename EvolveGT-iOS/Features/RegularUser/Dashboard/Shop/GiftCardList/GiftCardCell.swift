//
//  GiftCardCell.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 02/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import UIKit
import Kingfisher

class GiftCardCell: UITableViewCell {
    @IBOutlet weak var giftCardPriceLabel: UILabel!
    
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var giftCardImage: UIImageView!
    @IBOutlet weak var giftCardTitleLabel: UILabel!
  
    func showData(giftCard:GiftCard){
        
        giftCardPriceLabel.text = giftCard.price?.formatToAmount(prefix: "Price: ")
        giftCardTitleLabel.text = giftCard.title
        
        if  let url = URL(string : giftCard.image?.toValidatedImageUrl() ?? ""){
                  let fallbackImage = UIImage(named: "et_fallback_image")
                giftCardImage.kf.setImage(with: url,
                                         placeholder: fallbackImage,
                                         options: [.transition(ImageTransition.fade(1))])
                  
              }
        
       
        rootView.setCardView()
        
    }

}
