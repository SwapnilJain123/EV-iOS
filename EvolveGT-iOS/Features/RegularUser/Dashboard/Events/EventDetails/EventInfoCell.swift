//
//  EventInfoCell.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 15/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class EventInfoCell: UITableViewCell{
    
    
    @IBOutlet weak var eventBanner: UIImageView!
    
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var roleBasedPrice: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
    func showData(eventDetails : EventDetails?){
        if  let url = URL(string : eventDetails?.eventBanner ?? ""){
            let fallbackImage = UIImage(named: "et_fallback_image")
            eventBanner.kf.setImage(with: url,
                                   placeholder: fallbackImage,
                                   options: [.transition(ImageTransition.fade(1))])
            
        }
       
        eventDate.text = "Event Date: \(eventDetails?.eventDate?.formattedDate(outputFormat: .FORMAT_DD_MMM_YYYY) ?? "")"
    }
}

class AboutEventCell : UITableViewCell{
    
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var title: UILabel!
    
     func showData(eventDetails : EventDetails?){
        content.attributedText = eventDetails?.productInfo?.htmlAttributed
    }
}
