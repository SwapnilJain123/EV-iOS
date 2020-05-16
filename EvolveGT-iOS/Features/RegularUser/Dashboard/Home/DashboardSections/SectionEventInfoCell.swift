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
    func showEnrolledEventList(type : EventType)
    
}

enum EventType{
    case UPCOMING
    case PAST
}
class SectionEventInfoCell: UITableViewCell{
    
    
    var delegate : EventCellDelegate? = nil
    var type : EventType = .UPCOMING
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var eventType: UILabel!
    @IBOutlet weak var eventRightButton: UIButton!
    
    @IBOutlet weak var eventDetailView: UIView!
    
    
    @IBOutlet weak var eventImage: UIImageView!
    
    @IBOutlet weak var eventName: UILabel?
    
    @IBOutlet weak var eventDate: UILabel!
    
    @IBOutlet weak var orderDate: UILabel!
    
    @IBOutlet weak var buttonSeeMore: UIButton?
    
    var normalPlusImage : UIImage? = nil
    var selectionPlusImage : UIImage? = nil
    
    var normalMinusImage : UIImage? = nil
    var selectionMinusImage : UIImage? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    func applyTheme(){
        if AppEngine.sharedInstance.isEvApp(){
            
            normalPlusImage = UIImage(named: "ic_btn_plus_green")
            selectionPlusImage = UIImage(named: "ic_btn_plus_green_lite")
            
            normalMinusImage = UIImage(named: "ic_btn_minus_green")
            selectionMinusImage = UIImage(named: "ic_btn_minus_green_lite")
            
        }else{
            normalPlusImage = UIImage(named: "ic_btn_plus_blue")
            selectionPlusImage = UIImage(named: "plus_blue_lite")
            
            normalMinusImage = UIImage(named: "ic_btn_minus_blue")
            selectionMinusImage = UIImage(named: "ic_btn_minus_blue_lite")
            
        }
        
   
        let appColor = UIColor.getAppThemeColor()
        eventName?.textColor = appColor
        buttonSeeMore?.setTitleColor(appColor, for: .normal)
        
        
        eventRightButton.setImage(normalPlusImage, for: .normal)
        eventRightButton.setImage(selectionPlusImage, for: .selected)
    }
    func populateViews(type: EventType, _ event : EnrolledEvent, expanded: Bool){
        
        applyTheme()
        
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
            eventRightButton.setImage(normalPlusImage, for: .normal)
            eventRightButton.setImage(selectionPlusImage, for: .selected)
            
            
            
        }else{
            
            eventRightButton.setImage(normalMinusImage, for: .normal)
            eventRightButton.setImage(selectionMinusImage, for: .selected)
            
            eventName?.text = "Event: \(event.productName ?? "")"
            eventDate.text = "Event Date: \(event.eventDate?.formattedDate(outputFormat: .FORMAT_DD_MMM_YYYY) ?? "")"
            orderDate.text = "Order Date: \(event.orderDate?.formattedDate(inputPattern: .FORMAT_API_DATE, outputFormat: .FORMAT_DD_MMM_YYYY) ?? "")"
            if let imgUrl = event.eventImage{
                
                let placeHolder = UIImage(named: "et_fallback_image")
                self.eventImage.kf.setImage(with: URL(string : imgUrl), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
                
            }
        }
        containerView.setCardView()
        
    }
    
    
    @IBAction func toggleDetailsView(_ sender: Any) {
        delegate?.toggleEventDetails(type: self.type)
        
    }
    
    @IBAction func didPressSeeMore(_ sender: Any) {
        delegate?.showEnrolledEventList(type: self.type)
    }
    
}

