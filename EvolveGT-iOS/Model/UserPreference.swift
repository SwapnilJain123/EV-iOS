//
//  UserPreference.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 15/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class UserPreference: Codable {
    var title: String?
    var status, id: Int?
    init(){
        
    }
    init(id: Int?, title: String?, status: Int?){
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
