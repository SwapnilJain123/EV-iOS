//
//  PassportInfo.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 26/01/22.
//  Copyright © 2022 YaraTech. All rights reserved.
//

import Foundation
class PassportInfo : Codable{
    
    var eventId, userType,membershipLevel,userId, dayWorkerJob, groupLogo, riderName, skillLevel, picture, passportId, signedDate : String?
    var trainings: [String]?
    var isStamped: Int?
    var rentals: [Rental]?
    
    enum CodingKeys: String, CodingKey {
        case eventId = "event_id"
        case userType = "user_type"
        case membershipLevel = "membership_level"
        case userId = "user_id"
        case dayWorkerJob = "day_worker_job"
        case groupLogo = "group_logo"
        case riderName = "rider_name"
        case skillLevel = "skill_level"
        case trainings = "training"
        case picture = "picture"
        case passportId = "passport_id"
        case rentals = "rentals"
        case isStamped = "is_stamped"
        case signedDate = "signed_date"
        
    }
    
    var allTrainings : String{
        if trainings?.count ?? 0 == 0{
            return ""
        }
        return trainings!.joined(separator: ", ")
    }
    var allRentals : String{
        if rentals?.count ?? 0 == 0{
            return ""
        }
        return rentals!.map(){$0.name}.joined(separator: ", ")
    }
}
