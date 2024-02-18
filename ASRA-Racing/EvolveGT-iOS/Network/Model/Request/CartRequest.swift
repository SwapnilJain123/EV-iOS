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
    var role, title: String?
    var eventCouponCode : String?
    var serial: Int?
    var eventClasses: [EventClassRequest]?
    var eventID: Int?
    var transponderNo: String?
    var bikeNumber: String?
    var eventClassTotal : String?
    var skill : String?
    
    enum CodingKeys: String, CodingKey {
        case eventClasses = "classes"
        case eventDate = "event_date"
        case eventPrice = "event_price"
        case eventSlug = "event"
        case rentalList = "rental_list"
        case trainingList = "training_list"
        case serial, role, title
        case transponderNo = "transponder_no"
        
        case eventID = "event_id"
        case bikeNumber = "bike_no"
        case eventCouponCode = "secret_code"
        case skill = "racer_status"
        case eventClassTotal = "total_price"
    }
}
struct TrainingRequest: Codable {
    var price, slug, trainingName: String?
    var id: Int?
}

struct RentalRequest: Codable {
    var price, slug, selectedSize, rentalName: String?
    var id: Int?
}
struct ProductCartRequest: Codable {
    var selectedAttributes: [ProductCartAttribute]?
    var price: String?
    var quantity: Int?
    var slug: String?
    var serial: Int?
}

// MARK: - SelectedAttribute
struct ProductCartAttribute: Codable {
    var name, value: String?
}
struct CartRemoveRequest: Codable{
    var method: String?
    var cartId, userId, itemId: Int?
    
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
    var title, slug, image: String?
    var price: String?
    var quantity: Int?
    var serial: Int?
}

struct AddGiftCardToCartRequest: Codable {
    var email, name: String?
    var image: String?
    var price, quantity, slug: String?
    var title: String?
    var serial: Int?
}
struct AddMembershipToCartRequest: Codable{
    
    var image, membership, price, title: String?
    var userId: Int?
    var force: String = "0"
    enum CodingKeys: String, CodingKey {
        case image, membership, price, title, force
        case userId = "serial"
    }
}
struct TrackDayCartRequest: Codable {
    var eventId: Int?
    var userID: Int?
    enum CodingKeys: String, CodingKey {
        case userID = "serial"
        case eventId = "event"
    }
   
}

class EventClassRequest: Codable{
    
    var className, classId, raceName, raceId, bikeData, price: String?
    
    enum CodingKeys: String, CodingKey {
        case className = "class_name"
        case classId = "class_id"
        case raceName = "race_name"
        case raceId = "race_id"
        case bikeData = "bike_data"
        case price = "price"
    
        
    }
    
 

}
