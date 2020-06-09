//
//  Membership.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 04/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation

class Membership: Codable {
    var membershipID, title, slug, price: String?
    var stockStatus: String?
    var image: String?
    var season: String?
    
    enum CodingKeys: String, CodingKey {
        case membershipID = "membership_id"
        case title, slug, price
        case stockStatus = "stock_status"
        case image
    }
    
    var isGuest : Bool{
        "guest" == title?.lowercased()
    }
    var isOutOfStock : Bool{
        stockStatus?.isOutOfStock() ?? false
    }
    func canPurchase(currentMembership: String?) -> Bool{
        let currentId = Int(currentMembership ?? "") ?? 0
        let membershipId = Int(membershipID ?? "") ?? 0
        return !isGuest && (currentMembership == nil || currentId < membershipId)
        
    }
    
    var isCurrentMembership: Bool{
        AppEngine.sharedInstance.userRole.lowercased() == title?.lowercased()
    }
}
