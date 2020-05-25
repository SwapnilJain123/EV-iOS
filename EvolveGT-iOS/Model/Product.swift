//
//  Product.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct ProductCategory: Codable {
    var title, id: String?
    var children: [ProductCategory]?
    
    
    var isGear : Bool{
        "gear" == title?.lowercased()
    }
    
    var isRentals : Bool{
        "rentals" == title?.lowercased()
    }
}
struct Product: Codable {
    var productID, title, slug, image: String?
    var categoryID: String?

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case title, slug, image
        case categoryID = "category_id"
    }
}
