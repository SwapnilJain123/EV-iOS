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
    var countryCode: Int?
     enum CodingKeys: String, CodingKey {
        case countryCode = "country_code"
    }
}

class RegistrationRequest: Codable{
    var firstname, lastname, email, confirmEmail: String?
    var password, confirmPassword: String?
    var raceLicense: Int? = 0
    var everBeenTrack: Int? = 0
    var skillLevel, phone, dob: String?
    var gender: String? = "Male"
    var accept: Int? = 1
    var subscribeForDiscounts: Int?

    enum CodingKeys: String, CodingKey {
        case firstname, lastname, email
        case confirmEmail = "confirm_email"
        case password
        case confirmPassword = "confirm_password"
        case raceLicense = "race_license"
        case everBeenTrack = "ever_been_track"
        case skillLevel = "skill_level"
        case phone, dob, gender, accept
        case subscribeForDiscounts = "subscribe_for_discounts"
    }
}

class sendOTPRequest: Codable{
    var email: String?
    enum CodingKeys: String, CodingKey {
        case email
    }
}

class verifyOTPRequest: Codable{
    var email: String?
    var otp: String?
    enum CodingKeys: String, CodingKey {
        case email
        case otp
    }
}
