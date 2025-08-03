//
//  CartItem.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 26/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class CartItem: Codable {
    var slug: String?
    var title: String?
    var image: String?
    var price, feeAmount, quantity, postDate, parentID: String?
    var postModified: String?
    var source: CartSource?
    var stockStatus: String?
    var canRemove: Bool?
    var evtype: String?
    var itemAttributes: [CartItemAttribute]?
    var parentTitle, parentSlug: String?
    var userID, cartID, objectID: Int?
    
    var isMotoEvent : Bool{
        "motogladiator" == evtype?.lowercased()
    }
    var isRaceFee : Bool{
        "race-fee" == slug?.lowercased()
    }
    
    var isOutOfStock: Bool{
        stockStatus?.isOutOfStock() ?? false
    }
    
    var totalPrice: Double{
        let qty = Double(quantity ?? "1") ?? 1
        let fee = feeAmount?.toDouble() ?? 0
        let pricePerItem = price?.toDouble() ?? 0
        
        return (qty * pricePerItem) + fee
    }
    
    var priceInfoText : String{
        var text = "Qty: \(validatedQty)"
        let fee = feeAmount?.toDouble() ?? 0
        if fee > 0 {
            text = "\(text) | Fee: \(feeAmount!.formatToAmount())"
        }
        text = "\(text) | Price: \(price?.formatToAmount() ?? String.DEFAULT_AMOUNT)"
        return text
    }
    var validatedQty: Int{
       var qty = Int(quantity ?? "1") ?? 1
        qty = qty > 0 ? qty : 1
        return qty
    }
    
    var secondaryProperty : String {
        var property = ""
        switch source {
        case .product, .archie:
            property = "Quantity: \(validatedQty)"
        case .giftcard:
            if let attributes = itemAttributes{
                for attribute in attributes {
                    if attribute.name?.lowercased() == "name"{
                        property = "Gift to: \(attribute.value ?? "")"
                    }
                }
            }
        case .event:
            property = "Hosted By: \(evtype ?? "")"
        case .rentals, .training, .transponder:
            property = "Event: : \(parentTitle ?? "")"
        default:
            property = ""
        }
        return property
    }
    
    var tertiaryProperty : String{
        var property = ""
        switch source {
        case .product, .event, .rentals:
            if let attributes = itemAttributes{
                for attribute in attributes{
                    property = "\(property)\(attribute.name ?? "") : \(attribute.value ?? "") |"
                }
                if property.isEmpty == false {
                    property.removeLast(1)
                }
            }
        case .giftcard:
            if let attributes = itemAttributes{
                for attribute in attributes {
                    if attribute.name?.lowercased() == "email"{
                        property = attribute.value ?? ""
                    }
                }
            }
        default:
            property = ""
        }
        return property
    }
    enum CodingKeys: String, CodingKey {
        case cartID = "cart_id"
        case objectID = "object_id"
        case slug
        case parentID = "parent_id"
        case title, image, price
        case feeAmount = "fee_amount"
        case quantity
        case postDate = "post_date"
        case postModified = "post_modified"
        case source
        case userID = "user_id"
        case stockStatus = "stock_status"
        case canRemove = "can_remove"
        case evtype
        case parentSlug = "parent_slug"
        case itemAttributes = "item_attributes"
        case parentTitle = "parent_title"
    }
}

// MARK: - ItemAttribute
class CartItemAttribute: Codable {
    var name, value: String?
}
enum CartSource : String, Codable{
    case rentals
    case event
    case training
    case archie
    case giftcard
    case membership
    case transponder
    case racefee
    case product
    
}
