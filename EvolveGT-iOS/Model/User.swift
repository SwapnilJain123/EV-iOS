//
//  User.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct User: Codable {
    
    private static let ROLE_ADMIN = "administrator"
    private static let ROLE_COACH = "coach"
    
    
    var id, email, firstName, lastName: String
    var displayName, skillLevel, role: String
    var hasAdminPrevilege: Bool

    enum CodingKeys: String, CodingKey {
        case id, email
        case firstName = "first_name"
        case lastName = "last_name"
        case displayName = "display_name"
        case skillLevel = "skill_level"
        case hasAdminPrevilege = "admin_privilege"
        case role
    }
    
    func isAdmin() -> Bool{
        return role == User.ROLE_ADMIN
    }
    
    func isCoach() -> Bool{
        return role == User.ROLE_COACH
    }
    
    func isAdminOrCoach() -> Bool{
        return role == User.ROLE_COACH || role == User.ROLE_ADMIN
    }
}

//Mark: Roles - User Roles

enum UserRoles : String{
    case guest
    case grip
    case military
    case apex
    case coach
    case yg
    case racer
    case vip
    case dealer
    case motogirl
    case ocp
    case administrator
    
}

