//
//  EventGridCell.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 11/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import UIKit
import Kingfisher

class EventGridCell: UICollectionViewCell {
    
    @IBOutlet weak var hostingView: UIView!
    @IBOutlet weak var hostingHeight: NSLayoutConstraint!
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    
    
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var hostedBy: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var bannerCancelled: UIImageView!
    
    @IBOutlet weak var btnAddToCart: UIButton?
    
    @IBOutlet weak var hostIcon1: UIImageView?
    @IBOutlet weak var hostIcon2: UIImageView?
    @IBOutlet weak var hostIcon3: UIImageView?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        btnAddToCart?.isHidden = false
        bannerCancelled.isHidden = false
        
        hostIcon1?.image = nil
        hostIcon2?.image = nil
        hostIcon3?.image = nil
        
    }
    var event : Event? {
        didSet {
            updateViews()
        }
    }
    
    
    private func updateViews(){
        if  let url = URL(string : event?.eventLogo ?? ""){
            let fallbackImage = UIImage(named: "et_fallback_image")
            eventImage.kf.setImage(with: url,
                                   placeholder: fallbackImage,
                                   options: [.transition(ImageTransition.fade(1))])
            
        }
        eventName.text! = event?.title ?? ""
        eventDate.text = "Event Date: \(event?.eventDate?.formattedDate(outputFormat: .FORMAT_DD_MMM_YYYY) ?? "")"
        hostedBy.text = "Hosted By \(event?.eventType ?? "")"
        price.text = "Starting From: \((event?.getRoleBasedPrice(role: AppEngine.sharedInstance.userRole) ?? String.DEFAULT_AMOUNT).formatToAmount())"
        
        bannerCancelled.isHidden = !(event?.isCancelled ?? false)
        
        btnAddToCart?.isHidden = event!.isMotoEvent || (event?.isCancelled ?? false)
       
        let hostings = event?.activeHostings
        if let count = hostings?.count {
            if  count > 0{
                hostIcon1?.kf.setImage(with: URL(string: hostings?[0].url ?? ""), placeholder: nil, options:[.transition(ImageTransition.fade(1))])
            }
            if count > 1{
                hostIcon2?.kf.setImage(with: URL(string: hostings?[1].url ?? ""), placeholder: nil, options:[.transition(ImageTransition.fade(1))])
            }
            if count > 2{
                hostIcon3?.kf.setImage(with: URL(string: hostings?[2].url ?? ""), placeholder: nil, options:[.transition(ImageTransition.fade(1))])
            }
        }
        rootView.setCardView()
    }
}
