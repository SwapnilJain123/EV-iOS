//
//  Product.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct ProductCategory: Codable {
    var title: String?
    var children: [ProductCategory]?
    var id: Int?
    
    var isGear : Bool{
        "gear" == title?.lowercased()
    }
    
    var isRentals : Bool{
        "rentals" == title?.lowercased()
    }
}
struct Product: Codable {
    var title, slug, image: String?
    var categoryID: Int?
    var productID: Int?

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case title, slug, image
        case categoryID = "category_id"
    }
}
