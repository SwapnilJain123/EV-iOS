//
//  wavierCell.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 02/09/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import UIKit
import Kingfisher
protocol WaiverCellDelegate {
    func showWaiverDetailsPage(waiver:EWaiver)
}
class WavierCell: UITableViewCell {

    var detailsDelegate:WaiverCellDelegate?
    
    @IBOutlet weak var imgWaiver: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hostedLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBAction func wavierButton(_ sender: UIButton) {
        
        detailsDelegate?.showWaiverDetailsPage(waiver: waiver)
        
    }
    @IBOutlet weak var waiverButton: UIButton!
    
    var waiver = EWaiver()
    
    func showData(waiver:EWaiver){
        self.waiver = waiver
        titleLabel.text = waiver.title
        eventDateLabel.text = "Date:\(waiver.eventDate?.formattedDate(inputPattern: String.FORMAT_YYYY_MM_DD_HIPHEN, outputFormat: String.FORMAT_DD_MMM_YYYY) ?? "")"
        hostedLabel.text = "Hosted by \(waiver.eventType ?? "")"
        
        if  let url = URL(string : waiver.fullEventLogo?.toValidatedImageUrl() ?? ""){
                         let fallbackImage = UIImage(named: "et_fallback_image")
                       imgWaiver.kf.setImage(with: url,
                                                placeholder: fallbackImage,
                                                options: [.transition(ImageTransition.fade(1))])
                         
                     }
        titleLabel.textColor = .getAppThemeColor()
        waiverButton.applyColorTheme()
        waiverButton.superview?.setCardView()
        
        
    }
    
}
