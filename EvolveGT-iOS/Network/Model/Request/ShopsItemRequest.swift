//
//  ShopsItemRequest.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 15/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation

struct ItemDetailRequest: Codable {
    var slug: String?
    var postStatus = "publish"
}


struct EventDetailRequest: Codable {
    
    var postStatus = "publish"
    var slug: String?
    var serial: Int?

    enum CodingKeys: String, CodingKey {
        case postStatus = "post_status"
        case slug, serial
    }
}
struct ProductListRequest: Codable {
    var postStatus = "publish"
    var category : String?
    var status = "0"
    var method: String? = "product"
    var categoryIDList: Int?

    init(productCategory : ProductCategory, source: String){
        self.category = source
        self.categoryIDList = productCategory.id
        
    }
    enum CodingKeys: String, CodingKey {
        case postStatus = "post_status"
        case category, status, method
        case categoryIDList = "category_id_list"
    }
}
