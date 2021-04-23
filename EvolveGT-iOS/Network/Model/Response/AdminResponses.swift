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


// MARK: - CoachDutyResponse
struct CoachDutyResponse: Codable {
    
    var duties: AssignedDuty?
    
    enum CodingKeys: String, CodingKey {
        case duties = "result"
        
    }
}

// MARK: - Result
class AssignedDuty: Codable {
    var past: [EventDuty]?
    var upcoming: [EventDuty]?
    var current: [EventDuty]?
}

// MARK: - Past
class EventDuty: Codable {
    var eventID, event, eventYear, eventType: String?
    var eventDate: String?
    var duties: [Duty]?

    enum CodingKeys: String, CodingKey {
        case eventID = "event_id"
        case event
        case eventYear = "event_year"
        case eventType = "event_type"
        case eventDate = "event_date"
        case duties
    }
}

// MARK: - Duty
class Duty: Codable {
    var duty: String?
    var status: Bool?
}
