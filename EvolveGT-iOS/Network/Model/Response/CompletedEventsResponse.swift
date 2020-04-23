//
//  CompletedEventsResponse.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct CompletedEventsResponse : Decodable{
    
    var completedEvents: [CompletedEvent]
    
    
    enum CodingKeys: String, CodingKey {
           case completedEvents = "result"
    }
}
