//
//  File.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 18/09/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct SaveWaiverDetailsRequest: Codable {
    var userID, eventID, nameAndLocation, license: String?
    var issuingState, signature: String?
    var agree: Bool?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case eventID = "event_id"
        case nameAndLocation, license, issuingState, signature, agree
    }
}
