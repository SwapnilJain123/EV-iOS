//
//  EventParticipant.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 23/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct EventParticipant: Codable {
    var signatureID: String?
    var signature: Bool?
    var fourSeries, renewOnTen: String?
    
    var updated, status, title: String?
    var displayName, evDob, email, skillLevel: String?
    var userID, orderID: String?
    var eventID, eventDate : String?
    var role: String?
    var show: Bool?
    var signEnabled: Int?
    var rentals: [Rental]?
    var trainings: [String]?
    var motoClasses: [MotoClass]?
    var eWaiver, tdPurchased, motoPurchased: Bool?
    
    
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
    
    var hasAccessories : Bool{
        let trainingCount = trainings?.count ?? 0
        let rentalCount = rentals?.count ?? 0
        
        return (trainingCount + rentalCount) > 0
    }

    var isSignEnabled: Bool{
        signEnabled == 1
    }
    
    var isSignAndStarEnabled: Bool{
        signEnabled == 1 && hasAccessories
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
        case motoClasses = "moto_classes"
        case eWaiver = "e_waiver"
        case tdPurchased = "td_purchased"
        case motoPurchased = "moto_purchased"
    }
    
    struct Rental: Codable {
        var name, attribute, value: String
    }
    
    // MARK: - MotoClass
    struct MotoClass: Codable {
        var raceName: String?
        var raceClasses: [RaceClass]?

        enum CodingKeys: String, CodingKey {
            case raceName = "race_name"
            case raceClasses = "race_classes"
        }
    }

    // MARK: - RaceClass
    struct RaceClass: Codable {
        var className, bikeData: String?

        enum CodingKeys: String, CodingKey {
            case className = "class_name"
            case bikeData = "bike_data"
        }
    }

}

