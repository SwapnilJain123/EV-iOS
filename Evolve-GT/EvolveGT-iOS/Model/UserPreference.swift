//
//  UserPreference.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 15/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class UserPreference: Codable {
    var id, title: String?
    var status: Int?
    init(){
        
    }
    init(id: String?, title: String?, status: Int?){
        self.id = id
        self.title = title
        self.status = status
    }
    enum CodingKeys: String, CodingKey {
           case id, status
           case title = "type"
       }
    var isActive: Bool{
        status == 1
    }
}
