//
//  TransferAmountRequest.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 21/04/21.
//  Copyright © 2021 YaraTech. All rights reserved.
//

import Foundation
struct TransferAmountRequest: Codable {
    var userID, transferEmail , transferAmount: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case transferEmail = "transferEmail"
        case transferAmount = "transferAmount"
    }
}
