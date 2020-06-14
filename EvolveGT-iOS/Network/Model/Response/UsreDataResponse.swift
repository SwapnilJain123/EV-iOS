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
