//
//  ETResponse.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct ETResponse : Decodable {
    
    var status : Int?
    var msg : String?
    enum CodingKeys: String, CodingKey {
            case status
            case msg
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
       
        if let value = try? container.decode(String.self, forKey: .status) {
            status = Int(value) ?? 0
        } else {
            status = try container.decode(Int.self, forKey: .status)
        }
        
        if let valueMsg = try? container.decode(String.self, forKey: .msg) {
            msg = valueMsg
        }
    }
}
class CountryListResponse : Codable{
    var supportedCountries: [Country]?
    enum CodingKeys: String, CodingKey {
            case supportedCountries = "result"
           
    }
    
}
class StateListResponse : Codable{
    var supportedStates: [SupportedState]?
    
    enum CodingKeys: String, CodingKey {
            case supportedStates = "result"
           
    }
    
}
