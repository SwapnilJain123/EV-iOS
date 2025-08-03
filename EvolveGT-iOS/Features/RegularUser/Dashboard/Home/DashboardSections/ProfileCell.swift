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

protocol ProfileCellDelegate{
    func openEventHistory(eventType: Int)
}
class ProfileCell: UITableViewCell{
    
    var delegate: ProfileCellDelegate?
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var fullName: UILabel!
    
    @IBOutlet weak var joiningDate: UILabel!
    
    @IBOutlet weak var walletBalance: UILabel!
    
    
    @IBOutlet weak var customerID: UILabel!
    
    @IBOutlet weak var membershipExpiryDate: UILabel!
    
    @IBOutlet weak var membershipStatus: UILabel!
    
    @IBOutlet weak var upcomingEventsCount: UILabel!
    
    @IBOutlet weak var pastEventsCount: UILabel!
    
    @IBOutlet weak var AllEventsCount: UILabel!
    
    @IBOutlet weak var userSkillLevel: UILabel!
    
    @IBOutlet weak var personalInfoContainer: UIView!
    
    @IBOutlet weak var upcomingEventsContainer: UIView!
    
    @IBOutlet weak var skillLevelContainer: UIView!
    @IBOutlet weak var pastEventsContainer: UIView!
    
    @IBOutlet weak var allEventsContainer: UIView!
   
//    @IBOutlet weak var iconUpcomingEvents: UIImageView!
    
//    @IBOutlet weak var iconAllEvents: UIImageView!
//
//    @IBOutlet weak var iconPastEvents: UIImageView!
//
//    @IBOutlet weak var iconSkillLevel: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.showRoundCorner()
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.borderWidth = 2.0
        
        allEventsContainer.setCardView()
        upcomingEventsContainer.setCardView()
        skillLevelContainer.setCardView()
        pastEventsContainer.setCardView()
        
       
        
    }
    
    
    func applyTheme(){
        let appColor = UIColor.getAppThemeColor()
        personalInfoContainer.backgroundColor = appColor
        
//        
//        if AppEngine.sharedInstance.isEvApp(){
////          iconUpcomingEvents.image = UIImage(named: "upcoming_events")
//                     iconAllEvents.image = UIImage(named: "events_alltime")
//                     iconPastEvents.image = UIImage(named: "past_events")
//                     iconSkillLevel.image = UIImage(named: "skill_level")
//        }else{
////            iconUpcomingEvents.image = UIImage(named: "moto_upcoming_events")
//            iconAllEvents.image = UIImage(named: "moto_events_alltime")
//            iconPastEvents.image = UIImage(named: "moto_past_events")
//            iconSkillLevel.image = UIImage(named: "moto_skill_level")
//             // moto_events_alltime
//        }
    }
    
    func showData(_ profileData : ProfileData){
        
        applyTheme()
        if let imgUrl = profileData.imageUrl{
            
            let placeHolder = UIImage(named: "avatar")
            self.profileImage.kf.setImage(with: URL(string : imgUrl), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
        }
        
        fullName.text = profileData.fullName?.capitalizedAllWords()
        joiningDate.text = profileData.joiningDate
        walletBalance.text = profileData.walletBalance
        membershipExpiryDate.text = profileData.membershipExpiryDate
        membershipStatus.text = profileData.membershipStatus
        upcomingEventsCount.text = String(profileData.upComingEventsCount)
        pastEventsCount.text = String(profileData.pastEventsCount)
        AllEventsCount.text = String(profileData.allEventsCount)
        userSkillLevel.text = profileData.skillLevel
        customerID.text = profileData.customerID
    }
    
    @IBAction func didPressUpComingEvents(_ sender: Any) {
        delegate?.openEventHistory(eventType: EnrolledEventsSlidingTabController.TAB_UPCOMING)
    }
    
    @IBAction func didPressPastEvents(_ sender: Any) {
        delegate?.openEventHistory(eventType: EnrolledEventsSlidingTabController.TAB_PAST)
    }
    
    @IBAction func didPressAllEvents(_ sender: Any) {
        delegate?.openEventHistory(eventType: EnrolledEventsSlidingTabController.TAB_ALL_EVENTS)
    }
    
}

extension String {
    func capitalizedAllWords() -> String {
        var result = ""
        var capitalizeNext = true
        for char in self {
            if char.isLetter {
                result.append(capitalizeNext ? char.uppercased() : char.lowercased())
                capitalizeNext = false
            } else {
                result.append(char)
                capitalizeNext = true
            }
        }
        return result
    }
}

