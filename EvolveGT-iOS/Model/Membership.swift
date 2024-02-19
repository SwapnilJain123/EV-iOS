//
//  Membership.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 04/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation

class Membership: Codable {
    static let ID_MRL = 5
    var title, slug, price: String?
    var stockStatus: String?
    var image: String?
    var season: String?
    var membershipID: Int?
    
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
    func canPurchase(currentMembership: Int?) -> Bool{
        return !isGuest && (currentMembership == nil || (currentMembership ?? 0) < (membershipID ?? 0))
        
    }
    
    var isCurrentMembership: Bool{
        AppEngine.sharedInstance.userRole.lowercased() == title?.lowercased()
    }
}
struct MembershipDetails: Codable {
    var title, slug: String?
    var image: String?
    var price, stockStatus, description, packages: String?
    var postStatus, postDate, postModified: String?
    var status, membershipID, oldPostID, postAuthor: Int?
    var msg: String?

    enum CodingKeys: String, CodingKey {
        case membershipID = "membership_id"
        case oldPostID = "old_post_id"
        case title, slug, image, price
        case stockStatus = "stock_status"
        case description = "description"
        case packages
        case postStatus = "post_status"
        case postAuthor = "post_author"
        case postDate = "post_date"
        case postModified = "post_modified"
        case status, msg
    }
    
    func canPurchase(currentMembership: Int?) -> Bool{
        return !isGuest && (currentMembership == nil || (currentMembership ?? 0) < (membershipID ?? 0))
        
    }
    var isGuest : Bool{
        "guest" == title?.lowercased()
    }
    
}
struct MRLMeesageResponse: Codable {
    var status: Int?
    var title, msg: String?
}
