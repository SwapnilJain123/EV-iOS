//
//  ArchiCardCell.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 27/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import UIKit
import Kingfisher

class ArchiCardCell: UITableViewCell {
    
    @IBOutlet weak var archieCardLabel: UILabel!
    @IBOutlet weak var archieCardImage: UIImageView!
    func showData(archieCard:ArchieCard){
        
        if  let url = URL(string : archieCard.image?.toValidatedImageUrl() ?? ""){
            let fallbackImage = UIImage(named: "et_fallback_image")
          archieCardImage.kf.setImage(with: url,
                                   placeholder: fallbackImage,
                                   options: [.transition(ImageTransition.fade(1))])
            
        }
        
        archieCardLabel.text = archieCard.title
        
        archieCardImage.superview?.setCardView()
        
        
        
        
    }

   
}
