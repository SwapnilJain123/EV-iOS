//
//  EventParticipant.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 23/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct EventParticipant: Codable {
    var signatureID: String
    var signature: Bool
    var fourSeries, renewOnTen: String?
    
    var updated, status, title: String
    var displayName, evDob, email, skillLevel: String?
    var userID, orderID: String
    var eventID, eventDate : String
    var role: String?
    var show: Bool?
    var signEnabled: Int
    var rentals: [Rental]?
    var trainings: [String]?
    
    var namewithRole : String{
        
        if let name = displayName{
            if !(role?.isEmpty() ?? false){
                return "\(name)(\(role!))".uppercased()
            }else{
                return name.uppercased()
            }
        }else{
            return "-"
        }
        
    }
    
    var hasSignature : Bool{
        status == "1"
    }
    
    var hasTrainingOrRentals : Bool{
        ((trainings?.count ?? 0) + (rentals?.count ?? 0)) > 0
    }

    enum CodingKeys: String, CodingKey {
        case signatureID = "signature_id"
        case signature
        case fourSeries = "four_series"
        case renewOnTen = "renew_on_ten"
        case updated, status, title
        case displayName = "display_name"
        case evDob = "ev_dob"
        case email
        case skillLevel = "skill_level"
        case userID = "user_id"
        case orderID = "order_id"
        case eventID = "event_id"
        case eventDate = "event_date"
        case role, show
        case signEnabled = "sign_enabled"
        case rentals
        case trainings = "training"
    }
    
    struct Rental: Codable {
        var name, attribute, value: String
    }
}

