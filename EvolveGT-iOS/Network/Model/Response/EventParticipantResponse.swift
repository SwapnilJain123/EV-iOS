//
//  EventParticipantResponse.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 23/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct EventParticpantResponse: Codable {
    var count: Int
    var eventParticipants: [EventParticipant]
    
    enum CodingKeys: String, CodingKey {
           case eventParticipants = "result"
            case count
    }
}
