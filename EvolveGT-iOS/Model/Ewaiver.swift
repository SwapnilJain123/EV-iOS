//
//  Ewaiver.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 04/09/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation

class EWaiver : Codable{
    
    
    var eventDate, title, slug: String?
    var eventLogo, eventType: String?
    var fullEventLogo: String?
    var fullEventDate: String?
    var eventID: Int?

    enum CodingKeys: String, CodingKey {
        case eventID = "event_id"
        case eventDate = "event_date"
        case title, slug
        case eventLogo = "event_logo"
        case eventType = "event_type"
        case fullEventLogo = "full_event_logo"
        case fullEventDate = "full_event_date"
    }
    
}
