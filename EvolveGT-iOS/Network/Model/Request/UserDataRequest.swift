//
//  UserDataRequest.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 04/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation

struct UserDataUserIdRequest : Codable{
   var userID: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
       
    }
}

struct UserDataSerialRequest : Codable{
   var userID: String?

    enum CodingKeys: String, CodingKey {
        case userID = "serial"
       
    }
}

struct UserDetailsRequest : Codable{
   var userID: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
       
    }
}

struct EventHistoryRequest : Codable{
   var userID: String?
    var isMotoevent : Int?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case isMotoevent = "is_motoevent"
       
    }
}

struct CreditHistoryRequest : Codable{
   var userID: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
       
    }
}
