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
    
    func showPassport(event : EnrolledEvent)
    func uploadPassport(event : EnrolledEvent)
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
    
    @IBOutlet weak var btnShowPassport: UIButton?
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        cancelButton?.isHidden = false
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
    
    func populateViews(event : EnrolledEvent, isUpComing: Bool){
        
        self.event = event
        eventTitle.textColor = UIColor.getAppThemeColor()
        
        //let isPastEvet = event.eventDate?.isEalierThanToday(dateFormat: .FORMAT_YYYY_MM_DD_HIPHEN) ?? true
        if AppEngine.sharedInstance.canCancelEvent && isUpComing{
            cancelButton?.isHidden = false//was false. Cancel button moved to context menu
        }else{
            cancelButton?.isHidden = false
        }
        eventTitle.text = event.productName
        eventDate.text = "Date: \(event.eventDate?.formattedDate(inputPattern: .FORMAT_YYYY_MM_DD_HIPHEN, outputFormat: .FORMAT_DD_MMM_YYYY) ?? "")"
        orderDate.text = "Ordered On: \(event.orderDate?.formattedDate(inputPattern: .FORMAT_API_DATE, outputFormat: .FORMAT_DD_MMM_YYYY) ?? "")"
        if let imgUrl = event.eventImage{
            
            let placeHolder = UIImage(named: "et_fallback_image")
            self.eventImage.kf.setImage(with: URL(string : imgUrl), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
            
        }
        
        icAccessories.isHidden = true//Was  !event.hasAccessories. This moved to context menu
        if isUpComing{
            if event.hasPassport ?? false{
                btnShowPassport?.setTitle("Tech Passport", for: .normal)
                btnShowPassport?.isEnabled = true
            }else{
                btnShowPassport?.setTitle("I Am Here", for: .normal)
                btnShowPassport?.isEnabled = event.enableSelfsign ?? false
            }
            btnShowPassport?.isHidden = false
        }else{
            btnShowPassport?.isHidden = true
        }
        //btnShowPassport?.isHidden = !isUpComing || !(event.hasPassport ?? false)
        btnShowPassport?.applyColorTheme()
        self.containerView.setCardView()
        
    }
    @IBAction func didTapShowPassport(_ sender: UIButton) {
        if event?.hasPassport ?? false{
            delegate?.showPassport(event: event!)
        }else{
            delegate?.uploadPassport(event: event!)
        }
    }
}
