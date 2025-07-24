//
//  UserDataRequest.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 04/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation

struct UserDataUserIdRequest : Codable{
    var userID: Int?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        
    }
}

struct UserDataSerialRequest : Codable{
    var userID: Int?
    var isMoto: Int?
    
    enum CodingKeys: String, CodingKey {
        case userID = "serial"
        case isMoto = "is_moto"
        
    }
}

struct UserDetailsRequest : Codable{
    var userID: Int?
    var isMoto: Int?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case isMoto = "is_moto"
    }
}

struct NotificationListRequest : Codable{
    var pageNumber: Int?
    
    enum CodingKeys: String, CodingKey {
        case pageNumber = "page_number"
    }
}
    
struct EventHistoryRequest : Codable{
    var userID: Int?
    var isMotoevent : Int?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case isMotoevent = "is_motoevent"
        
    }
}

struct CreditHistoryRequest : Codable{
    var userID: Int?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        
    }
}
struct PasswordChangeRequest: Codable {
    var userID: Int?
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
    
    var skillLevel: String?
    var orderItemId, userId: Int?
    
    enum CodingKeys: String, CodingKey {
        case orderItemId = "order_item_id"
        case userId = "user_id"
        case skillLevel = "skill_level"
    }
}

struct UserMemberShipRequest: Codable{
    
    var userId: Int?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        
    }
}
class ProfileUpdateRequest: Codable {
    var requestBody: ProfileRequestInfo?
    var userID: Int?
    
    enum CodingKeys: String, CodingKey {
        case requestBody = "data"
        case userID = "user_id"
    }
}
struct SaveUserAgreementRequest: Codable {
    
    var userID: Int?
    var agreementStatus: Bool?
    enum CodingKeys: String, CodingKey {
        case agreementStatus = "has_agreed"
        case userID = "serial"
    }
}

class ProfileRequestInfo: Codable {
    var evDob, evEmergencyFirstName, evEmergencyLastName, evEmergencyPhone: String?
    var evEmergencyRelationship, firstName, evGender: String?
    var lastName, amaExpires, amaNo,email, asraNo: String?
    var ccsNo, raceNo, sponsors, teamnames: String?
    var evMotorcycle, evMotorcycleNumber, nationality, phone: String?
    var evRaceLicence, motoSkill: String?
    var everBeenTrack: Int?
    var bikes: [Bike]?
    var region:String?
    
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
        case motoSkill = "moto_skill"
        case bikes, region
    }
}
struct BillingAdressUpdateRequest:Codable {
    var userId: Int?
    var billingRequest:BillingAdressRequest?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case billingRequest = "data"
        
    }
    
}

struct BillingAdressRequest:Codable {
    var billingAdress1:String?
    var billingAdress2:String?
    var billingCity:String?
    var billingCountry:String?
    var billingEmail:String?
    var billingFirstName:String?
    var billingLastName:String?
    var billingPhone:String?
    var billingPostCode:String?
    var billingState:String?
    
    enum CodingKeys: String, CodingKey {
        case  billingAdress1 = "billing_address_1"
        case billingAdress2 = "billing_address_2"
        case billingCity = "billing_city"
        case billingCountry = "billing_country"
        case billingEmail = "billing_email"
        case billingFirstName = "billing_first_name"
        case billingLastName = "billing_last_name"
        case billingPhone = "billing_phone"
        case billingPostCode = "billing_postcode"
        case billingState = "billing_state"
        
    }
    
}

struct ShippingAdressUpdateRequest:Codable {
    
    var userID: Int?
    var shippingRequest:ShippingAddressRequest?
    
    enum CodingKeys: String, CodingKey {
        
        case userID = "user_id"
        case shippingRequest = "data"
        
        
    }
}

struct ShippingAddressRequest:Codable {
    
    var shippingAddress1:String?
    var shippingCity:String?
    var shippingCountry:String?
    var shippingFirstName:String?
    var shippingLastName:String?
    var shippingPostCode:String?
    var shippingState:String?
    
    init(){
        
    }
    enum CodingKeys: String, CodingKey {
        
        case shippingAddress1 = "shipping_address_1"
        case shippingCity = "shipping_city"
        case shippingCountry = "shipping_country"
        case shippingFirstName = "shipping_first_name"
        case shippingLastName = "shipping_last_name"
        case shippingPostCode = "shipping_postcode"
        case shippingState = "shipping_state"
        
        
        
    }
}



struct NotificationPreferenceUpdateRequest: Codable{
    var userId: Int?
    var preferences: [NotificationTypeUpdate]?
    

     enum CodingKeys: String, CodingKey {

        case userId = "user_id"
        case preferences
    }
}

struct NotificationTypeUpdate: Codable{
    var notificationType, notificationStatus : String?
    var notificationId: Int?
    
    enum CodingKeys: String, CodingKey {
        case notificationType = "notification_type"
         case notificationId = "notification_id"
         case notificationStatus = "status"
    }
}
struct DeviceTokenRequest: Codable{
    var userId: Int?
    var token: String?
    var deviceType = "iOS";
    enum CodingKeys: String, CodingKey {
         case userId = "user_id"
         case token
         case deviceType = "device_type"

    }
}

struct TransferAmountRequest: Codable {
    var transferEmail , transferAmount: String?
    var userID: Int?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case transferEmail = "transferEmail"
        case transferAmount = "transferAmount"
    }
}
struct EmergencyContactRequest: Codable {
    var emergencyFirstName, emergencyLastName, emergencyPhone: String?
    var userID: Int?
    var emergencyRelationship: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case emergencyFirstName = "emergency_first_name"
        case emergencyLastName = "emergency_last_name"
        case emergencyPhone = "emergency_phone"
        case emergencyRelationship = "emergency_relationship"
    }
}
