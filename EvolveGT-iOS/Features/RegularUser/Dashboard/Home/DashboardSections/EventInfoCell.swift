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

protocol EventCellDelegate{
    func toggleEventDetails(type : EventType)
}

enum EventType{
    case UPCOMING
    case PAST
}
class EventInfoCell: UITableViewCell{
    
    
    var delegate : EventCellDelegate? = nil
    var type : EventType = .UPCOMING
    
    
    @IBOutlet weak var eventType: UILabel!
    @IBOutlet weak var eventRightButton: UIButton!
    
    @IBOutlet weak var eventDetailView: UIView!
    
    
    @IBOutlet weak var eventImage: UIImageView!
    
    @IBOutlet weak var eventName: UILabel!
    
    @IBOutlet weak var eventDate: UILabel!
    
    @IBOutlet weak var orderDate: UILabel!
    
    @IBOutlet weak var buttonSeeMore: UIButton!
    
    func populateViews(type: EventType, _ event : EnrolledEvent, expanded: Bool){
        self.type = type
        if type == .PAST{
            eventType.text = ScreenTitle.TITLE_PAST_EVENTS
        }else{
            eventType.text = ScreenTitle.TITLE_UPCOMING_EVENTS
        }
        
        if expanded == false{
            
            if eventDetailView != nil {
                eventDetailView.removeFromSuperview()
            }
            //plus button
            let image = UIImage(named: "plus_green")
            eventRightButton.setImage(image, for: .normal)
        }else{
            let image = UIImage(named: "minus_green")
            eventRightButton.setImage(image, for: .normal)
            
            eventName.text = "Event: \(event.productName ?? "")"
                   eventDate.text = "Event Date: \(event.eventDate?.formattedDate(outputFormat: .FORMAT_DD_MMM_YYYY) ?? "")"
                   orderDate.text = "Order Date: \(event.orderDate?.formattedDate(inputPattern: .FORMAT_API_DATE, outputFormat: .FORMAT_DD_MMM_YYYY) ?? "")"
                  if let imgUrl = event.eventImage{
                       
                       let placeHolder = UIImage(named: "et_fallback_image")
                       self.eventImage.kf.setImage(with: URL(string : imgUrl), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
                       
                   }
        }
        
       
        
    }
    
    
    @IBAction func toggleDetailsView(_ sender: Any) {
        delegate?.toggleEventDetails(type: self.type)
       
    }
}

