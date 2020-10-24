//
//  ProfileData.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 05/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct ProfileData{
    
    var imageUrl: String? = nil
    var fullName : String? = ""
    var joiningDate : String? = ""
    
    var walletBalance : String? = ""
    var membershipStatus : String? = ""
    var membershipExpiryDate : String? = ""
    
    var skillLevel : String? = ""
    var upComingEventsCount : Int = 0
    var pastEventsCount : Int = 0
    var allEventsCount : Int = 0
    
    var recentUpComingEvent : EnrolledEvent? = nil
    var recentPastEvent : EnrolledEvent? = nil
    var recentCreditHistory : CreditHistory? = nil
    
    var componentCount = 4
    
    mutating func create(with userDetails: UserDetails){
        self.imageUrl = userDetails.fullProfileImage
        self.fullName = userDetails.fullName
        if let joiningDate = userDetails.registered{
            self.joiningDate = "Member Since: \(joiningDate.formattedDate(inputPattern: .FORMAT_API_DATE, outputFormat: .FORMAT_DD_MMM_YYYY))"
        }else{
            self.joiningDate = ""
        }
        
        self.walletBalance = userDetails.walletAmount?.formatToAmount()
         
        if let expiryDate = userDetails.membershipExpDate{
            self.membershipExpiryDate = expiryDate.formattedDate(inputPattern: .FORMAT_API_DATE, outputFormat: .FORMAT_DD_MMM_YYYY)
            if expiryDate.isEalierThanToday(dateFormat: .FORMAT_API_DATE){
                self.membershipStatus = "INACTIVE"
            }else{
                self.membershipStatus = "ACTIVE (\(userDetails.evRole?.capitalized ?? ""))"
            }
        }else{
            self.membershipExpiryDate = ""
            self.membershipStatus = "INACTIVE"
        }
        
        if(AppEngine.sharedInstance.currentUser?.isAdminOrCoach() ?? false){
            self.skillLevel = AppEngine.sharedInstance.currentUser?.role.capitalized
        }else{
         self.skillLevel = AppEngine.sharedInstance.isEvApp() ? userDetails.skillLevel : userDetails.motoSkill
        }
    }
}
