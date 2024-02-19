//
//  EventResponse.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 12/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct EventListResponse : Decodable{
    
    var events: [Event]?
    
    enum CodingKeys: String, CodingKey {
        case events = "results"
    }
}

struct ArchiCardListResponse: Codable {
    
    var archieCardList: [ArchieCard]?
    enum CodingKeys: String, CodingKey {
        case archieCardList = "data"
    }
}


struct ArchieCardDetailsResponse: Codable {
    
    var archieCards: ArchieCardDetails?
    
    enum CodingKeys: String, CodingKey {
        case archieCards = "data"
    }
}

struct GiftCardListResponse:Decodable {
    
    var status: Int?
    var msg: String?
    var giftCardList: [GiftCard]?
    enum CodingKeys: String, CodingKey {
    case giftCardList = "data"
        
    }
    
}

struct GiftCardDetailsResponse: Codable {
    var status: Int?
    var msg: String?
    var giftCardDetails: GiftCardDetails?
    enum CodingKeys: String, CodingKey {
       case giftCardDetails = "data"
           
       }
}

struct CategoryListResponse: Codable {
    
    var category: [ProductCategory]?
    
    enum CodingKeys: String, CodingKey {
        case category = "data"
    }
}

struct ProductListResponse: Codable {
    var products: [Product]?
    
    enum CodingKeys: String, CodingKey {
        case products = "results"
    }
}
