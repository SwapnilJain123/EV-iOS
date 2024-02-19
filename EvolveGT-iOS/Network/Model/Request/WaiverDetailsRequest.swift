//
//  WaiverDetailsRequest.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 11/09/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct WaiverDetailsRequest: Codable {
    var userID, eventID: Int?
    
    enum CodingKeys: String, CodingKey {
        case eventID = "event_id"
        case userID = "user_id"
    }
}
