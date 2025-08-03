//
//  EventDetails.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 15/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class EventDetails: Codable {
    var title, eventDate, productInfo: String?
    var logoIcon: String?
    var eventBanner: String?
    var price, eventType, stock: String?
    var eventClasses: [EventClass]?
    var hasRaceLicense, skillEligible: Bool?
    var eventID: Int?
    var trackDays: [Event]?
    var isPrivateEvent: Bool?
    var isCancelled : Bool?
    var slug : String? = ""
    var transponderNo : String? = ""
    var roleBasedPrice: RoleBasedPrice? = RoleBasedPrice()
    var trainingData: [TrainingDatum]?
    var rentalData: [RentalDatum]?
    var external: ExternalHost?
    
    var selectedSkill = ""
    var isMotoEvent = false
    
    var racerStatus : String?
    var bikeNo : String?
    var hasRaceLicence : Bool?
    var trackValidation : Bool?
    var mrlValidation : Bool?
    var mrlHTML : String?
    var mrlAddToCart : Bool?
    var registrationClosed : Bool?
    var mrlData: MrlData?
    
    var registeredSkill = ""
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
        
        if let eventRaceClasses = eventClasses{
            for eventClass in eventRaceClasses {
                totalPrice = totalPrice + (eventClass.getSelectedClassPrice())
            }
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
    
   
    
    var selectedEventClasses :[EventClassRequest]{
        var requestList = [EventClassRequest]()
        if eventClasses?.count ?? 0 > 0 {
            for eventClass in eventClasses! {
                for raceClass in eventClass.raceClasses! {
                    if (raceClass.checked ?? false) && (raceClass.bikeData?.isNotEmpty ?? false) {
                        let classRequest = EventClassRequest()
                        classRequest.bikeData = raceClass.bikeData
                        classRequest.classId = raceClass.classID
                        classRequest.className = raceClass.className
                        classRequest.price = "\(raceClass.classPrice ?? 0)"
                        classRequest.raceId = eventClass.raceID
                        classRequest.raceName = eventClass.raceName
                        requestList.append(classRequest)
                    }
                }
            }
        }
        return requestList
        
    }
    
    var selectedEventClassTotal :String{
        var total: Double = 0.0
        if let allEventClasses : [EventClass] = eventClasses{
            for eventClass in allEventClasses {
                total = total + eventClass.getSelectedClassPrice()
            }
        }
        return String(total)
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
        case trackDays
        case trainingData, rentalData
        case isPrivateEvent = "is_private_event"
        case roleBasedPrice
        case isCancelled = "is_cancelled"
        case external
        
        case transponderNo = "transponder_no"
        case racerStatus = "racer_status"
        case bikeNo = "bike_no"
        case hasRaceLicence = "has_race_licence"
        case trackValidation = "trackValidation"
        case mrlValidation = "mrlValidation"
        case mrlHTML = "mrlHTML"
        case mrlData = "mrlData"
        case mrlAddToCart = "mrlAddToCart"
        case registrationClosed = "registration_closed"
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
    //var stock: String?
    var stockStatus: String?
    var attributeName: String?
    var attributeValue: String?
    
    enum CodingKeys: String, CodingKey {
        case price //, stock
        case stockStatus = "stock_status"
        case attributeName = "attribute_name"
        case attributeValue = "attribute_value"
    }
    
    var isOutOfStock: Bool{
        stockStatus?.isOutOfStock() ?? false
    }
}


class MrlData: Codable{
    
    var membership : String?
    var title : String?
    
    var price : String?
    var image : String?
    var force = 0
    var userID : Int?
    var season : String?
    var slug : String?
    var membershipId : Int?
    
    enum CodingKeys: String, CodingKey {
        case membership = "membership"
        case title, slug, force,  image, season, price
        case userID = "serial"
        case membershipId = "membership_id"
    }
    
    
}

class RentalDatum: Codable {
    var title, slug: String?
    var variations: [Variation]?
    var image: String?
    var productID: Int?
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
    var title, price, slug: String?
    var image: String?
    var trainingID: Int?
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
