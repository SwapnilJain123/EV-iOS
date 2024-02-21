//
//  EnrolledEvent.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 05/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class EnrolledEvent: Codable {
    var productName, orderStatus, orderDate, eventDate: String?
    var eventImage: String?
    var eventMonth: String?
    var orderItemID: Int?
    var rentals: [Rental]?
    var trainings: [String]?
    var motoClasses: [MotoClass]?
    
    var hasPassport, enableSelfsign: Bool?
    var passportId: Int?
    var eventId: Int?
    
    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case orderStatus = "order_status"
        case orderDate = "order_date"
        case eventDate = "event_date"
        case eventImage = "event_image"
        case orderItemID = "order_item_id"
        case eventMonth = "event_month"
        case rentals
        case trainings = "training"
        case motoClasses = "moto_classes"
        
        case hasPassport = "has_passport"
        case enableSelfsign = "enable_selfsign"
        case passportId = "passport_id"
        case eventId = "event_id"
    }
    
    var hasAccessories : Bool{
        let rentalCount = rentals?.count ?? 0
        let trainingCount = trainings?.count ?? 0
        let motoClassCount = motoClasses?.count ?? 0
        
        return (rentalCount + trainingCount + motoClassCount) > 0
    }
    
    var canUploadPassport : Bool{
        let now = Date()
        let hour = Calendar.current.component(.hour, from: now)
        
        let dateComponents = eventDate!.components(separatedBy: "-")
        
        let newDate = Date.createDateFrom(year: Int(dateComponents[0]) ?? 0, month: Int(dateComponents[1]) ?? 0, day: Int(dateComponents[2]) ?? 0)
        if let date = newDate{
            let canUpload =  Calendar.current.isDateInYesterday(date) && hour >= 18
            return canUpload || Calendar.current.isDateInToday(date)
        }
        return false
    }
}
