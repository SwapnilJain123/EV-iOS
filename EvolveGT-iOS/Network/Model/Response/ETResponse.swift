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
    var errorCode : Int?
    
    enum CodingKeys: String, CodingKey {
        case status
        case msg
        case errorCode
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
        if let code = try? container.decode(Int.self, forKey: .errorCode) {
            errorCode = code
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
