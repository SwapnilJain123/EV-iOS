//
//  EventCartRequest.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 14/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct EventCartRequest: Codable {
    
    var eventDate, eventPrice, eventSlug: String?
    
    var rentalList: [RentalRequest]?
    var trainingList: [TrainingRequest]?
    var serial, role, title: String?
    var eventCouponCode : String?
    
    var eventClasses: [String]?
    var eventID: String?
    var transponderRented: Bool?
    var transponderNo: String?
    var eventClassTotal : String?
    var skill : String?
    
    enum CodingKeys: String, CodingKey {
        case eventClasses = "classes"
        case eventDate = "event_date"
        case eventPrice = "event_price"
        case eventSlug = "event"
        case transponderRented = "transponder_rented"
        case rentalList = "rental_list"
        case trainingList = "training_list"
        case serial, role, title
        case transponderNo = "transponder_no"
        
        case eventID = "event_id"
        
        case eventCouponCode = "secret_code"
        case skill = "skill_class"
        case eventClassTotal = "amount"
    }
}
struct TrainingRequest: Codable {
    var price, slug, id, trainingName: String?
}

struct RentalRequest: Codable {
    var price, slug, id, selectedSize, rentalName: String?
}
struct ProductCartRequest: Codable {
    var selectedAttributes: [ProductCartAttribute]?
    var price: String?
    var quantity: Int?
    var slug, serial: String?
}

// MARK: - SelectedAttribute
struct ProductCartAttribute: Codable {
    var name, value: String?
}
struct CartRemoveRequest: Codable{
    var cartId, userId, itemId, method: String?
    
    init(cartItem : CartItem){
        self.cartId = cartItem.cartID
        self.userId = cartItem.userID
        self.itemId = cartItem.objectID
        self.method = cartItem.source?.rawValue
    }
    
      enum CodingKeys: String, CodingKey {
        case cartId = "cartid"
        case itemId = "itemid"
        case method
        case userId = "id"
    }
    
    
}

struct AddArchieCardToCartRequest: Codable {
    var serial, title, slug, image: String?
    var price: String?
    var quantity: Int?
}

struct AddGiftCardToCartRequest: Codable {
    var email, name: String?
    var image: String?
    var serial, price, quantity, slug: String?
    var title: String?
}

