//
//  UsreDataResponse.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 04/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct UserDetailsResponse : Decodable{
    
    var userDetails: UserDetails?
    
    enum CodingKeys: String, CodingKey {
        case userDetails = "result"
    }
}
struct EventsHistoryResponse : Decodable{
    
    var enrolledEvents: [EnrolledEvent]?
    
    enum CodingKeys: String, CodingKey {
        case enrolledEvents = "events"
    }
}
struct CreditHistoryResponse : Decodable{
    
    var creditHistoryList: [CreditHistory]?
    
    enum CodingKeys: String, CodingKey {
        case creditHistoryList = "result"
    }
}
struct MembershipListResponse: Codable {
    var memberships: [Membership]?
    var season: String?
}


struct UserMembershipResponse: Codable {
    
    var membershipId: String?
    enum CodingKeys: String, CodingKey {
        case membershipId = "membership_id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let value = try? container.decode(Int.self, forKey: .membershipId) {
            membershipId = String(value)
        } else {
            membershipId = try container.decode(String.self, forKey: .membershipId)
        }
    }
}
struct UserTermsAcceptanceResponse: Codable {
    var status: Int?
    var msg: String?
    var agrreementStatus: AgreementStatus?
    
    enum CodingKeys: String, CodingKey {
        case agrreementStatus = "data"
    }
}
struct NotificationTypesResponse: Codable {
    var preferences: [UserPreference]?
    
    enum CodingKeys: String, CodingKey {
        case preferences = "result"
    }
}

struct WaiverListResponse: Codable {
    var status: Int?
    var msg: String?
    var result: [EWaiver]?
    var count: Int?
}


struct WaiverDeatailsResponse: Codable {
    var status: Int?
    var msg: String?
    var eventData: EventData?
    var userData: UserData?
    var states: [State]?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case eventData = "event_data"
        case userData = "user_data"
        case states
    }
}

struct ReferFriendResponse: Codable {
    var status: Int?
    var msg: String?
}

struct ViewPassportResponse: Codable {
    var status: Int?
    var msg: String?
    var data: PassportInfo?
}
