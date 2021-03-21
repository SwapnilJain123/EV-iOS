//
//  UserDetails.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 04/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation

class UserDetails: Codable {
    var userID, oldID, username, password: String?
    var nicename, email, url, registered: String?
    var activationKey, hashCode, status, displayName: String?
    var nickname, firstName, lastName, profileImage: String?
    var billingPhone, billingFirstName, billingLastName, billingCompany: String?
    var billingEmail, billingCountry, billingAddress1, billingAddress2: String?
    var billingCity, billingState, billingPostcode, shippingFirstName: String?
    var shippingLastName, shippingCompany, shippingAddress1, shippingAddress2: String?
    var shippingCity, shippingPostcode, shippingCountry, shippingState: String?
    var shippingMethod, evRole, evGender, evRaceLicence: String?
    var evDob, evMotocycleYear, evMotorcycle, evMotorcycleNumber: String?
    var evMotorcycleShiftPattern, evMedications, evMedicalConditions, evEmergencyFirstName: String?
    var evEmergencyLastName, evEmergencyPhone, evEmergencyRelationship, evStaff: String?
    var memo, skillLevel, n2Rider, walletAmount: String?
    var membershipExpDate, newsletter, everBeenTrack, adminNotes: String?
    var adminKey, motoCount, raceNumber: String?
    var eventCancel: Bool?
    var hasRCT,transponderNo: String?
    var motoSkill, raceNo, amaNo, amaExpires: String?
    var amaExpiry, ccsNo, asraNo, nationality: String?
    var sponsors, teamnames, shippingCountryName, billingCountryName: String?
    var shippingStateName, billingStateName: String?
    var fullProfileImage: String?
    var customerID: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case oldID = "old_id"
        case username, password, nicename, email, url, registered
        case activationKey = "activation_key"
        case hashCode = "hash_code"
        case status
        case displayName = "display_name"
        case nickname
        case firstName = "first_name"
        case lastName = "last_name"
        case profileImage = "profile_image"
        case billingPhone = "billing_phone"
        case billingFirstName = "billing_first_name"
        case billingLastName = "billing_last_name"
        case billingCompany = "billing_company"
        case billingEmail = "billing_email"
        case billingCountry = "billing_country"
        case billingAddress1 = "billing_address_1"
        case billingAddress2 = "billing_address_2"
        case billingCity = "billing_city"
        case billingState = "billing_state"
        case billingPostcode = "billing_postcode"
        case shippingFirstName = "shipping_first_name"
        case shippingLastName = "shipping_last_name"
        case shippingCompany = "shipping_company"
        case shippingAddress1 = "shipping_address_1"
        case shippingAddress2 = "shipping_address_2"
        case shippingCity = "shipping_city"
        case shippingPostcode = "shipping_postcode"
        case shippingCountry = "shipping_country"
        case shippingState = "shipping_state"
        case shippingMethod = "shipping_method"
        case evRole = "ev_role"
        case evGender = "ev_gender"
        case evRaceLicence = "ev_race_licence"
        case evDob = "ev_dob"
        case evMotocycleYear = "ev_motocycle_year"
        case evMotorcycle = "ev_motorcycle"
        case evMotorcycleNumber = "ev_motorcycle_number"
        case evMotorcycleShiftPattern = "ev_motorcycle_shift_pattern"
        case evMedications = "ev_medications"
        case evMedicalConditions = "ev_medical_conditions"
        case evEmergencyFirstName = "ev_emergency_first_name"
        case evEmergencyLastName = "ev_emergency_last_name"
        case evEmergencyPhone = "ev_emergency_phone"
        case evEmergencyRelationship = "ev_emergency_relationship"
        case evStaff = "ev_staff"
        case memo
        case skillLevel = "skill_level"
        case n2Rider = "n2_rider"
        case walletAmount = "wallet_amount"
        case membershipExpDate = "membership_exp_date"
        case newsletter
        case everBeenTrack = "ever_been_track"
        case adminNotes = "admin_notes"
        case adminKey = "admin_key"
        case motoCount = "moto_count"
        case raceNumber = "race_number"
        case eventCancel = "event_cancel"
        case hasRCT
        case transponderNo = "transponder_no"
        case motoSkill = "moto_skill"
        case raceNo = "race_no"
        case amaNo = "ama_no"
        case amaExpires = "ama_expires"
        case amaExpiry = "ama_expiry"
        case ccsNo = "ccs_no"
        case asraNo = "asra_no"
        case nationality, sponsors, teamnames
        case shippingCountryName = "shipping_country_name"
        case billingCountryName = "billing_country_name"
        case shippingStateName = "shipping_state_name"
        case billingStateName = "billing_state_name"
        case fullProfileImage = "full_profile_image"
        case customerID = "customer_number"
       
    }
    
    var hasValidBillingAddress : Bool{
        !(billingFirstName?.isEmpty ?? true || billingLastName?.isEmpty ?? true
        || billingAddress1?.isEmpty() ?? true || billingState?.isEmpty ?? true
        || billingCity?.isEmpty() ?? true || billingCountry?.isEmpty() ?? true
        || billingPhone?.isEmpty() ?? true)
    }
    public static let GENDER_MALE = "male"
    public static let GENDER_FEMALE = "female"
    
    public  func isMale() -> Bool{
        return UserDetails.GENDER_MALE == self.evGender
    }

    public func isFeMale() -> Bool{
       return UserDetails.GENDER_FEMALE == self.evGender
    }

    public var fullName : String {
        return "\(firstName ?? "") \(lastName ?? "")"
    }
    
    var billingAddress : String{
        let fullName = "\(billingFirstName ?? firstName ?? "") \(billingLastName ?? lastName ?? "")"
        if billingAddress1?.isEmpty() ?? true{
            return ""
        }else{
            var address = "\(fullName.capitalized)\n\(billingAddress1!)"
            
            if billingAddress2?.isEmpty() ?? true == false{
                           address = "\(address)\n\(billingAddress2!)"
            }
            if billingCompany?.isEmpty() ?? true == false{
                           address = "\(address)\n\(billingCompany!)"
            }
            let state = billingState?.isEmpty ?? true ? "" : "\(billingState!) - "
            if billingCity?.isEmpty() ?? true == false{
                address = "\(address)\n\(billingCity!), \(state)\(billingPostcode ?? "")"
            }
            if billingCountry?.isEmpty() ?? true == false{
                           address = "\(address)\n\(billingCountry!)"
            }
             if billingPhone?.isEmpty() ?? true == false{
                 address = "\(address)\nCell: \(billingPhone!)"
            }
            return address
        }
    }
    
    var shippingAddress : String{
        let fullName = "\(shippingFirstName ?? firstName ?? "") \(shippingLastName ?? lastName ?? "")"
        if shippingAddress1?.isEmpty() ?? true{
            return ""
        }else{
            var address = "\(fullName.capitalized)\n\(shippingAddress1!)"
            
            if shippingAddress2?.isEmpty() ?? true == false{
                           address = "\(address)\n\(shippingAddress2!)"
            }
            if shippingCompany?.isEmpty() ?? true == false{
                           address = "\(address)\n\(shippingCompany!)"
            }
            
            if shippingCity?.isEmpty() ?? true == false{
                address = "\(address)\n\(shippingCity!), \(shippingState ?? "")-\(shippingPostcode ?? "")"
            }
            if shippingCountry?.isEmpty() ?? true == false{
                           address = "\(address)\n\(shippingCountry!)"
            }
            return address
        }
    }
    var canBuyMRLMembership: Bool{
        "1" == evRaceLicence
    }
    var hasEverBeenOnTrack :Bool{
        "1" == everBeenTrack
    }
}
