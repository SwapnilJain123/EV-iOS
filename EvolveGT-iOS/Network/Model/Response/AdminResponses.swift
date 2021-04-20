//
//  CompletedEventsResponse.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct CompletedEventsResponse : Decodable{
    
    var completedEvents: [CompletedEvent]
    
    
    enum CodingKeys: String, CodingKey {
        case completedEvents = "result"
    }
}
struct EventParticpantResponse: Codable {
    var count: Int
    var eventParticipants: [EventParticipant]
    var generalSkills: [String]
    
    enum CodingKeys: String, CodingKey {
        case eventParticipants = "result"
        case generalSkills = "general_skills"
        case count
    }
}
struct CoachDutyResponse: Codable {
    
    var assignedEvents: [AssignedEvent]?
    
    enum CodingKeys: String, CodingKey {
        case assignedEvents = "result"
    }
}
