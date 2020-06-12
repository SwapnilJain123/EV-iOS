//
//  LoginRequest.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct LoginRequest : Encodable {
    let emailLogin, passwordLogin: String
    let remember: Bool

    enum CodingKeys: String, CodingKey {
        case emailLogin = "email_login"
        case passwordLogin = "password_login"
        case remember
    }
}
struct SupportedStateRequest: Codable {
    var countryCode: String?
     enum CodingKeys: String, CodingKey {
        case countryCode = "country_code"
    }
}
