//
//  EnrolledEvent.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 05/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct EnrolledEvent: Codable {
    var productName, orderStatus, orderDate, eventDate: String?
    var eventImage: String?
    var orderItemID, eventMonth: String?

    var rentals: [Rental]?
    var trainings: [String]?
    var motoClasses: [MotoClass]?
    
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
    }
    
    var hasAccessories : Bool{
        let rentalCount = rentals?.count ?? 0
        let trainingCount = trainings?.count ?? 0
        let motoClassCount = motoClasses?.count ?? 0
        
        return (rentalCount + trainingCount + motoClassCount) > 0
    }
}
