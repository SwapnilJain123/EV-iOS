//
//  EventCartRequest.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 14/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct EventCartRequest: Codable {
    
    var eventDate, eventPrice, eventSlug: String?
    
    var rentalList: [Rentals]?
    var trainingList: [Trainings]?
    var serial, role, title: String?
    var eventCouponCode : String?
    
    var classes: [String]?
    var eventID: String?
    var transponderRented: Bool?
    var transponderNo: String?
    
    enum CodingKeys: String, CodingKey {
        case classes
        case eventDate = "event_date"
        case eventPrice = "event_price"
        case eventSlug = "event"
        case transponderRented = "transponder_rented"
        case rentalList = "rental_list"
        case trainingList = "training_list"
        case serial, role, title
        case transponderNo = "transponder_no"
        
        case eventID = "event_id"
        
        case eventCouponCode = "secret_code"
    }
    
    struct Trainings: Codable {
        var price, slug, id, trainingName: String?
    }
    
    struct Rentals: Codable {
        var price, slug, id, rentalName: String?
    }
}
