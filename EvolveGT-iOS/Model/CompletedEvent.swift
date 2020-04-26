//
//  CompletedEvent.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct CompletedEvent: Decodable {
   
        var eventID, title, eventDate: String
        var eventLogo: String
        var eventType: String
        var trainingType: [String]?

        enum CodingKeys: String, CodingKey {
            case eventID = "event_id"
            case title
            case eventDate = "event_date"
            case eventLogo = "event_logo"
            case eventType = "event_type"
            case trainingType = "training_type"
        }
   

    
}
