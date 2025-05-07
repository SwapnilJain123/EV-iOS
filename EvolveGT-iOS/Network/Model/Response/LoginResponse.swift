//
//  LoginResponse.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation

struct LoginResponse: Decodable{
    var token: String
    var currentUser: User
}
struct ForgotPasswordResponse: Codable {
    var status: Int?
    var msg: String?
}
struct OTPSendResponse: Decodable{
    var status: Int?
    var msg: String?
}
struct verifyOTPResponse: Decodable{
    var status: Int?
    var msg: String?
}

struct ThemeResponse: Decodable{
    var status: Int?
    var msg: String?
    var result: ThemeData
}

