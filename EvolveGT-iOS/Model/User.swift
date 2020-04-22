//
//  User.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct User: Codable {
    var id, email, firstName, lastName: String
    var displayName, skillLevel, role: String

    enum CodingKeys: String, CodingKey {
        case id, email
        case firstName = "first_name"
        case lastName = "last_name"
        case displayName = "display_name"
        case skillLevel = "skill_level"
        case role
    }
}
