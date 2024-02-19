//
//  UpgradeSkillRequest.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 28/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct UpgradeSkillRequest: Codable {
    var skilllevel: String?
    var userID: Int?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case skilllevel
    }
}
