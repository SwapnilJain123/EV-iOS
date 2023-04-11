//
//  CreditHistory.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 05/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct CreditHistory: Codable {
    var paymentLogID, amount, mode, isCredit: String?
    var orderID, userID, postDate, postModified: String?
    var creditHistoryDescription: String?

    enum CodingKeys: String, CodingKey {
        case paymentLogID = "payment_log_id"
        case amount, mode
        case isCredit = "is_credit"
        case orderID = "order_id"
        case userID = "user_id"
        case postDate = "post_date"
        case postModified = "post_modified"
        case creditHistoryDescription = "description"
    }
}
