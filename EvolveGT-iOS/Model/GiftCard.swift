//
//  GiftCard.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 02/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation

    struct GiftCard: Codable {
        var title, slug, content: String?
        var image: String?
        var price: String?
    }

struct GiftCardDetails: Codable {
    var title, slug, content: String?
    var image: String?
    var price: String?
}


