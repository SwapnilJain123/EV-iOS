//
//  ShopsItemRequest.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 15/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct EventDetailRequest: Codable {
    
    var postStatus = "publish"
    var slug, serial: String?

    enum CodingKeys: String, CodingKey {
        case postStatus = "post_status"
        case slug, serial
    }
}
