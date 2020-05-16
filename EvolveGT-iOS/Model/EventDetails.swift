//
//  EventDetails.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 15/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct EventDetails: Codable {
    var eventID, title, eventDate, productInfo: String?
    var logoIcon: String?
    var eventBanner: String?
    var price, eventType, stock: String?
    var eventClasses: [EventClass]?
    var hasRaceLicense, skillEligible: Bool?
    var skillSet: [SkillSet]?
    var transponder: Transponder?
    var trackDays: [Event]?
    var isPrivateEvent: Bool?
    
    var roleBasedPrice: RoleBasedPrice? = RoleBasedPrice()
    var trainingData: [TrainingDatum]?
    var rentalData: [RentalDatum]?
    
    
    
    enum CodingKeys: String, CodingKey {
        case eventID = "event_id"
        case title
        case eventDate = "event_date"
        case productInfo = "product_info"
        case logoIcon = "logo_icon"
        case eventBanner = "event_banner"
        case price
        case eventType = "event_type"
        case stock
        case eventClasses = "classes"
        case hasRaceLicense = "has_race_license"
        case skillEligible = "skill_eligible"
        case skillSet = "skill_set"
        case transponder, trackDays
        case trainingData, rentalData
        case isPrivateEvent = "is_private_event"
        case roleBasedPrice
    }
    
}


struct RoleBasedPrice: Codable {
    var guest, grip, military, apex: String?
    var coach, yg, racer, vip: String?
    var dealer, motogirl, ocp, administrator: String?
}

// MARK: - Variation
struct Variation: Codable {
    var price: String?
    var stock: String?
    var stockStatus: String?
    var attributeName: String?
    var attributeValue: String?
    
    enum CodingKeys: String, CodingKey {
        case price, stock
        case stockStatus = "stock_status"
        case attributeName = "attribute_name"
        case attributeValue = "attribute_value"
    }
}



// MARK: - Class
struct EventClass: Codable {
    var id: Int?
    var classClass: String?
    var active, inCart: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case classClass = "class"
        case active, inCart
    }
}

// MARK: - SkillSet
struct SkillSet: Codable {
    var id: Int?
    var skill: String?
    var active: Bool?
}

// MARK: - Transponder
struct Transponder: Codable {
    var price: Int?
    var imageURL: String?
    var inCart: Bool?
    var number: String?
    
    enum CodingKeys: String, CodingKey {
        case price
        case imageURL = "image_url"
        case inCart, number
    }
}

struct RentalDatum: Codable {
    var productID, title, slug: String?
    var variations: [Variation]?
    var image: String?
    
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case title, slug, variations,  image
    }
}

struct TrainingDatum: Codable {
    var trainingID, title, price, slug: String?
    var image: String?
    
    enum CodingKeys: String, CodingKey {
        case trainingID = "training_id"
        case title, price, slug, image
    }
}
