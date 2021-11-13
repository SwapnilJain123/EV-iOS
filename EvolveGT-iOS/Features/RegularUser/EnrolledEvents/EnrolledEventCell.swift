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
    
    func showAccessories(event : EnrolledEvent)
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
    @IBOutlet weak var icAccessories: UIImageView!
    
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        cancelButton?.isHidden = true
        eventTitle.textColor = UIColor.getAppThemeColor()
    }
    
    
    @IBAction func didPressAccessories(_ sender: UIButton) {
        if event?.hasAccessories ?? false{
            delegate?.showAccessories(event: event!)
        }
    }
    @IBAction func didPressCancel(_ sender: Any) {
        delegate?.cancelEvent(event: event!)
    }
    
    func populateViews(event : EnrolledEvent){
        
        self.event = event
        eventTitle.textColor = UIColor.getAppThemeColor()
        
        let isPastEvet = event.eventDate?.isEalierThanToday(dateFormat: .FORMAT_YYYY_MM_DD_HIPHEN) ?? true
        if AppEngine.sharedInstance.canCancelEvent && !isPastEvet{
            cancelButton?.isHidden = false
        }else{
             cancelButton?.isHidden = true
        }
        eventTitle.text = event.productName
        eventDate.text = "Date: \(event.eventDate?.formattedDate(inputPattern: .FORMAT_YYYY_MM_DD_HIPHEN, outputFormat: .FORMAT_DD_MMM_YYYY) ?? "")"
        orderDate.text = "Ordered On: \(event.orderDate?.formattedDate(inputPattern: .FORMAT_API_DATE, outputFormat: .FORMAT_DD_MMM_YYYY) ?? "")"
        if let imgUrl = event.eventImage{
            
            let placeHolder = UIImage(named: "et_fallback_image")
            self.eventImage.kf.setImage(with: URL(string : imgUrl), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
            
        }
        
        icAccessories.isHidden = !event.hasAccessories
        cancelButton?.setBorderColor(color: .red)
        self.containerView.setCardView()
        
    }
}
