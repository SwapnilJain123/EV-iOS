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
