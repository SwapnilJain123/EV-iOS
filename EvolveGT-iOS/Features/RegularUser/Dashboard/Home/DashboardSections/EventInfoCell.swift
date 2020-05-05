//
//  EventInfoCell.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 05/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class EventInfoCell: UITableViewCell{
    enum EventType{
        case UPCOMING
        case PAST
    }
    @IBOutlet weak var eventType: UILabel!
    @IBOutlet weak var eventRightButton: UIButton!
    
    @IBOutlet weak var eventDetailView: UIView!
    
    
    @IBOutlet weak var eventImage: UIImageView!
    
    @IBOutlet weak var eventName: UILabel!
    
    @IBOutlet weak var eventDate: UILabel!
    
    @IBOutlet weak var orderDate: UILabel!
    
    @IBOutlet weak var buttonSeeMore: UIButton!
    
    func populateViews(type: EventType, _ event : EnrolledEvent){
        if type == .PAST{
            eventType.text = ScreenTitle.TITLE_PAST_EVENTS
        }else{
            eventType.text = ScreenTitle.TITLE_UPCOMING_EVENTS
        }
        eventName.text = "Event: \(event.productName ?? "")"
        eventDate.text = "Event Date: \(event.eventDate?.formattedDate(outputFormat: .FORMAT_DD_MMM_YYYY) ?? "")"
        orderDate.text = "Order Date: \(event.orderDate?.formattedDate(inputPattern: .FORMAT_API_DATE, outputFormat: .FORMAT_DD_MMM_YYYY) ?? "")"
       if let imgUrl = event.eventImage{
            
            let placeHolder = UIImage(named: "et_fallback_image")
            self.eventImage.kf.setImage(with: URL(string : imgUrl), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
            
        }
        
        
    }
}

