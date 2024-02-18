//
//  ReferFriendRequest.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 20/09/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct ReferFriendRequest: Codable {
    var friendEmail: String?
    var userID: Int?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case friendEmail = "friend_email"
    }
}
