//
//  CompletedEventCell.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
class CompletedEventCell: UITableViewCell{
    
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    
    @IBOutlet weak var eventDate: UILabel!
    
    
    func showData(completdEvent: CompletedEvent){
        eventTitle.textColor = UIColor.getAppThemeColor()
        eventTitle.text! = completdEvent.title ?? ""
        eventDate.text! = completdEvent.eventDate?.formattedDate(inputPattern: .FORMAT_YYYY_MM_DD_HIPHEN, outputFormat: .FORMAT_DD_MMM_YYYY) ?? ""
        let imageUrl =  completdEvent.eventLogo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ?? ""
        
        if  let url = URL(string : imageUrl){
             let fallbackImage = UIImage(named: "et_fallback_image")
            eventImage.kf.setImage(with: url,
                                   placeholder: fallbackImage,
                                   options: [.transition(ImageTransition.fade(1))])
            
        }
        
    }
}
