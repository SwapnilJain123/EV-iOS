//
//  CoachDuty.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 13/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct AssignedEvent: Codable {
    var eventID, event, eventType, eventDate: String?
    var duties: [Duty]?

    enum CodingKeys: String, CodingKey {
        case eventID = "event_id"
        case event
        case eventType = "event_type"
        case eventDate = "event_date"
        case duties
    }
}

// MARK: - Duty
struct Duty: Codable {
    var duty: String?
    var status: Bool?
}
