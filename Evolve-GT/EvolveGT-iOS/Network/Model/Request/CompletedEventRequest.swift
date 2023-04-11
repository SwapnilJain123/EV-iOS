//
//  CompletedEventRequest.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct CompletedEventRequest: Codable {
    var isMotoevent: Int
    var userID: String

    enum CodingKeys: String, CodingKey {
        case isMotoevent = "is_motoevent"
        case userID = "userId"
    }
}
