//
//  EnrolledEventCell.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 09/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

protocol EnrolledEventCellDelegate{
    func cancelEvent(event : EnrolledEvent)
}
class EnrolledEventCell : UITableViewCell{
    
    var event : EnrolledEvent?
    var delegate : EnrolledEventCellDelegate?
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var eventImage: UIImageView!
    
    @IBOutlet weak var eventTitle: UILabel!
    
    @IBOutlet weak var eventDate: UILabel!
    
    @IBOutlet weak var orderDate: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton?
    
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        cancelButton?.isHidden = true
        eventTitle.textColor = UIColor.getAppThemeColor()
    }
    
    
    @IBAction func didPressCancel(_ sender: Any) {
        delegate?.cancelEvent(event: event!)
    }
    
    func populateViews(event : EnrolledEvent){
        
        self.event = event
        eventTitle.textColor = UIColor.getAppThemeColor()
        
        if AppEngine.sharedInstance.canCancelEvent{
            cancelButton?.isHidden = false
        }else{
             cancelButton?.isHidden = true
        }
        eventTitle.text = event.productName
        eventDate.text = "Date: \(event.eventDate?.formattedDate(outputFormat: .FORMAT_DD_MMM_YYYY) ?? "")"
        orderDate.text = "Ordered On: \(event.orderDate?.formattedDate(inputPattern: .FORMAT_API_DATE, outputFormat: .FORMAT_DD_MMM_YYYY) ?? "")"
        if let imgUrl = event.eventImage{
            
            let placeHolder = UIImage(named: "et_fallback_image")
            self.eventImage.kf.setImage(with: URL(string : imgUrl), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
            
        }
        
        cancelButton?.setBorderColor(color: .red)
        self.containerView.setCardView()
        
    }
}
