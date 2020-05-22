//
//  EventDetails.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 15/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class EventDetails: Codable {
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
    var isCancelled : Bool?
    var slug : String? = ""
    var roleBasedPrice: RoleBasedPrice? = RoleBasedPrice()
    var trainingData: [TrainingDatum]?
    var rentalData: [RentalDatum]?
     var external: ExternalHost?
    
    var selectedSkill = ""
    var isMotoEvent = false
    
    var total : Double {
        var totalPrice : Double = 0
        
        if !isMotoEvent{
            totalPrice = getRoleBasedPrice(role: AppEngine.sharedInstance.userRole).toDouble()
        }
        if let trainings = trainingData{
            for training in trainings where training.isSelected{
                totalPrice = totalPrice + (training.price?.toDouble() ?? 0.0)!
            }
        }
        
        if let rentals = rentalData{
            for rental in rentals where rental.selectedVariant != nil{
                totalPrice = totalPrice + (rental.selectedVariant?.price?.toDouble() ?? 0.0)!
            }
        }
        
        if let allEventClasses = eventClasses{
            for eventClass in allEventClasses where (eventClass.isSelected && !(eventClass.inCart ?? false)){
                totalPrice = totalPrice + (price?.toDouble() ?? 0)
            }
        }
        
        if transponder?.isSelected ?? false{
            totalPrice = totalPrice + Double(transponder?.price ?? 0)
        }
        
        return totalPrice
    }
    
    var isOutofStock : Bool{
        if let rentals = rentalData{
            for rental in rentals where rental.selectedVariant != nil{
                if rental.selectedVariant?.isOutOfStock ?? false{
                    return true
                }
            }
        }
        return false
    }
    var couponCode: String = ""
    
    var activeEventClasses: [EventClass]{
        var activeEventClasses = [EventClass]()
        if let allEventClasses : [EventClass] = eventClasses{
            for eventClass in allEventClasses where eventClass.active ?? false{
                activeEventClasses.append(eventClass)
            }
        }
        return activeEventClasses
    }
    
    var selectedEventClasses :[String]{
        var eventClassList = [String]()
         if let allEventClasses : [EventClass] = eventClasses{
            for eventClass in allEventClasses where eventClass.isSelected || (eventClass.inCart ?? false){
                eventClassList.append(eventClass.eventClassName!)
            }
        }
        return eventClassList
    }
    
    var selectedEventClassTotal :String{
        var total: Double = 0.0
         if let allEventClasses : [EventClass] = eventClasses{
            for eventClass in allEventClasses where eventClass.isSelected{
                total = total + (price?.toDouble() ?? 0.0)
            }
        }
        return String(total)
    }
    
    var hasSkillRegistered : Bool{
        if let availableSkillSet: [SkillSet] = skillSet{
            for skill in availableSkillSet where skill.active ?? false{
                return true
            }
        }
        return false
    }
    enum CodingKeys: String, CodingKey {
        case eventID = "event_id"
        case title
        case eventDate = "event_date"
        case productInfo = "product_info"
        case logoIcon = "logo_icon"
        case eventBanner = "event_banner"
        case price
        case slug
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
        case isCancelled = "is_cancelled"
        case external
    }
    
    func  getRoleBasedPrice(role : String) -> String{
        if roleBasedPrice?.hasKey(for: role) ?? false{
            return roleBasedPrice.value(for: role) as! String
        }else{
            return price ?? String(0)
        }
    }
    
}


class RoleBasedPrice: Codable {
    var guest, grip, military, apex: String?
    var coach, yg, racer, vip: String?
    var dealer, motogirl, ocp, administrator: String?
}

// MARK: - Variation
class Variation: Codable {
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
    
    var isOutOfStock: Bool{
        stockStatus?.isOutOfStock() ?? false
    }
}



// MARK: - Class
class EventClass: Codable {
    var id: Int?
    var eventClassName: String?
    var active, inCart: Bool?
    
    var isSelected = false
    enum CodingKeys: String, CodingKey {
        case id
        case eventClassName = "class"
        case active, inCart
    }
    
    
}

// MARK: - SkillSet
class SkillSet: Codable {
    var id: Int?
    var skill: String?
    var active: Bool?
}

// MARK: - Transponder
class Transponder: Codable {
    var price: Int?
    var imageURL: String?
    var inCart: Bool?
    var number: String?
    var isSelected = false
    
    enum CodingKeys: String, CodingKey {
        case price
        case imageURL = "image_url"
        case inCart, number
    }
}

class RentalDatum: Codable {
    var productID, title, slug: String?
    var variations: [Variation]?
    var image: String?
    
    var selectedVariant : Variation? = nil
    
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case title, slug, variations,  image
    }
    
    var variantOptions: [String]{
        var variants = [String]()
        if let rentalVariations = variations{
            for rentVariant in rentalVariations{
                variants.append(rentVariant.attributeValue ?? "")
            }
        }
        return variants
    }
    
    func findVariantByValue(value: String) -> Variation?{
        return variations?.first{value == $0.attributeValue}
    }
}

class TrainingDatum: Codable {
    var trainingID, title, price, slug: String?
    var image: String?
    
    var isSelected = false
    enum CodingKeys: String, CodingKey {
        case trainingID = "training_id"
        case title, price, slug, image
    }
}
extension String{
    func isOutOfStock() -> Bool{
        !("instock" == self.lowercased())
    }
}
