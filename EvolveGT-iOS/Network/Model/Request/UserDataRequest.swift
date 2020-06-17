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
struct PasswordChangeRequest: Codable {
    var userID: String?
    var passwordRequestBody: PasswordRequestBody?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case passwordRequestBody = "data"
    }
}

// MARK: - PasswordRequestBody
struct PasswordRequestBody: Codable {
    var currentpassword, password, confirmPassword: String?
    
    enum CodingKeys: String, CodingKey {
        case currentpassword, password
        case confirmPassword = "confirm-password"
    }
}
struct CancelEventRequest: Codable{
    
    var orderItemId, userId, skillLevel: String?
    
    enum CodingKeys: String, CodingKey {
        case orderItemId = "order_item_id"
        case userId = "user_id"
        case skillLevel = "skill_level"
    }
}
struct UserMemberShipRequest: Codable{
    
    var userId: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
      
    }
}
class ProfileUpdateRequest: Codable {
    var requestBody: ProfileRequestInfo?
    var userID: String?

    enum CodingKeys: String, CodingKey {
        case requestBody = "data"
        case userID = "user_id"
    }
}
struct SaveUserAgreementRequest: Codable {
   
    var userID: String?
    var agreementStatus: Bool?
    enum CodingKeys: String, CodingKey {
        case agreementStatus = "has_agreed"
        case userID = "serial"
    }
}

class ProfileRequestInfo: Codable {
    var evDob, evEmergencyFirstName, evEmergencyLastName, evEmergencyPhone: String?
    var evEmergencyRelationship, everBeenTrack, firstName, evGender: String?
    var lastName, amaExpires, amaNo,email, asraNo: String?
    var ccsNo, raceNo, sponsors, teamnames: String?
    var evMotorcycle, evMotorcycleNumber, nationality, phone: String?
    var evRaceLicence: String?

    enum CodingKeys: String, CodingKey {
        case evDob = "ev_dob"
        case email
        case evEmergencyFirstName = "ev_emergency_first_name"
        case evEmergencyLastName = "ev_emergency_last_name"
        case evEmergencyPhone = "ev_emergency_phone"
        case evEmergencyRelationship = "ev_emergency_relationship"
        case everBeenTrack = "ever_been_track"
        case firstName = "first_name"
        case evGender = "ev_gender"
        case lastName = "last_name"
        case amaExpires = "ama_expires"
        case amaNo = "ama_no"
        case asraNo = "asra_no"
        case ccsNo = "ccs_no"
        case raceNo = "race_no"
        case sponsors, teamnames
        case evMotorcycle = "ev_motorcycle"
        case evMotorcycleNumber = "ev_motorcycle_number"
        case nationality, phone
        case evRaceLicence = "ev_race_licence"
    }
}
struct NotificationPreferenceUpdateRequest: Codable{
    var userId: String?
    var preferences: [NotificationTypeUpdate]?
    
     enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case preferences
    }
}
struct NotificationTypeUpdate: Codable{
    var notificationType, notificationId, notificationStatus : String?
    enum CodingKeys: String, CodingKey {
        case notificationType = "notification_type"
         case notificationId = "notification_id"
         case notificationStatus = "status"
    }
}
struct DeviceTokenRequest: Codable{
    var userId: String?
    var token: String?
    var deviceType = "iOS";
    enum CodingKeys: String, CodingKey {
         case userId = "user_id"
         case token
         case deviceType = "device_type"
    }
}
