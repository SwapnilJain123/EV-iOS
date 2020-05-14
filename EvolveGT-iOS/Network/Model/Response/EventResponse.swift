//
//  EventResponse.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 12/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct EventListResponse : Decodable{
    
    var events: [Event]?
    
    enum CodingKeys: String, CodingKey {
           case events = "results"
    }
}
