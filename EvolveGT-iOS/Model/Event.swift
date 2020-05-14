//
//  Event.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 11/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct Event: Codable {
    var eventID: String?
    
    var title, price: String?
    
    var eventType: String?
    var eventDate, slug: String?
    var isRoleBasedPricing: String?
    var evType: String?
    var hostings: [EventHost]?
    var isCancelled, isPrivateEvent: Bool?
    var rolePrice: [String: RolePrice]?
    var eventLogo: String?
    var external: ExternalHost?
    
    enum CodingKeys: String, CodingKey {
        case eventID = "event_id"
        case title, price
        case eventType = "event_type"
        case eventDate = "event_date"
        case slug
        case isRoleBasedPricing = "is_role_based_pricing"
        case evType = "ev_type"
        case hostings
        case isCancelled = "is_cancelled"
        case isPrivateEvent = "is_private_event"
        case rolePrice
        case eventLogo = "full_event_logo"
        case external
    }
    
    func getRoleBasedPrice(role : String?) -> String{
        return rolePrice?[role ?? "guest"]?.regularPrice ?? price ?? "0"
    }
    
    var isMotoEvent : Bool!{
        "motogladiator" == eventType?.lowercased()
    }
    
    var activeHostings : [EventHost]?{
        hostings?.filter{$0.status ?? false} ?? nil
    }
}



// MARK: - External
struct ExternalHost: Codable {
    var url: String?
    var text: String?
}

// MARK: - Hosting
struct EventHost: Codable {
    var id: Int?
    var type: String?
    var url: String?
    var status: Bool?
}



// MARK: - RolePrice
struct RolePrice: Codable {
    var regularPrice: String?
    
    enum CodingKeys: String, CodingKey {
        case regularPrice = "regular_price"
    }
}
