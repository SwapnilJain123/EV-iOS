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

    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case orderStatus = "order_status"
        case orderDate = "order_date"
        case eventDate = "event_date"
        case eventImage = "event_image"
        case orderItemID = "order_item_id"
        case eventMonth = "event_month"
    }
}
