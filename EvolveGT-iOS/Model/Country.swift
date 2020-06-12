//
//  Country.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 12/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation

struct Country: Codable {
    var countryID, value, country: String?

    enum CodingKeys: String, CodingKey {
        case countryID = "country_id"
        case value, country
    }
}
struct SupportedState: Codable {
    var sortName, name: String?

    enum CodingKeys: String, CodingKey {
        case sortName = "sort_name"
        case name
    }
}
