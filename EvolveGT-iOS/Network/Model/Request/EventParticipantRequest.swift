//
//  EventParticipantRequest.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 23/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation

struct EventParticipantRequest: Codable {
    var eventID: String

    enum CodingKeys: String, CodingKey {
        case eventID = "event_id"
    }
}
