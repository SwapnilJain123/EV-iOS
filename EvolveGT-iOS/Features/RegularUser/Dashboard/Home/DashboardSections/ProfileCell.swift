//
//  ProfileCell.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 05/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class ProfileCell: UITableViewCell{
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var fullName: UILabel!
    
    @IBOutlet weak var joiningDate: UILabel!
    
    @IBOutlet weak var walletBalance: UILabel!
    
    @IBOutlet weak var membershipExpiryDate: UILabel!
    
    @IBOutlet weak var membershipStatus: UILabel!
    
    @IBOutlet weak var upcomingEventsCount: UILabel!
    
    @IBOutlet weak var pastEventsCount: UILabel!
    
    @IBOutlet weak var AllEventsCount: UILabel!
    
    @IBOutlet weak var userSkillLevel: UILabel!
    
    
    @IBOutlet weak var upcomingEventsContainer: UIView!
    
    @IBOutlet weak var skillLevelContainer: UIView!
    @IBOutlet weak var pastEventsContainer: UIView!
    
    @IBOutlet weak var allEventsContainer: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.showRoundCorner()
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.borderWidth = 2.0
        
        allEventsContainer.setCardView()
        upcomingEventsContainer.setCardView()
        skillLevelContainer.setCardView()
        pastEventsContainer.setCardView()
        // Initialization code
    }
    
    func showData(_ profileData : ProfileData){
        if let imgUrl = profileData.imageUrl{
            
            let placeHolder = UIImage(named: "avatar")
            self.profileImage.kf.setImage(with: URL(string : imgUrl), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
            
        }
        
        fullName.text = profileData.fullName
        joiningDate.text = profileData.joiningDate
        walletBalance.text = profileData.walletBalance
        membershipExpiryDate.text = profileData.membershipExpiryDate
        membershipStatus.text = profileData.membershipStatus
        upcomingEventsCount.text = String(profileData.upComingEventsCount)
        pastEventsCount.text = String(profileData.pastEventsCount)
        AllEventsCount.text = String(profileData.allEventsCount)
        userSkillLevel.text = profileData.skillLevel
        
    }
}
