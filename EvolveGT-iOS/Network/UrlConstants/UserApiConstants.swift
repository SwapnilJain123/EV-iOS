//
//  LoginUrlConstants.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct UserApiConstants{
    
    static let LOGIN = "/evolve-api/public/app/v3/user/auth"
    static let FORGOT_PASSWORD = "/evolve-api/public/app/v3/user/forgotPassword"
    static let CHANGE_PASSWORD = "/evolve-api/public/app/v3/user/changePassword"
    static let USER_DETAILS = "/evolve-api/public/app/v3/user/details"
    static let USER_EVENT_HISTORY = "/evolve-api/public/app/v3/user/allEvents"
    static let USER_CREDIT_HISTORY = "/evolve-api/public/user/creditHistory"
    
    //Mark Notifications
    static let NOTIFICATION_TYPES = "/evolve-api/public/app/v3/notifications/types"
    static let UPDATE_NOTIFICATION_PREF = "/evolve-api/public/app/v3/notifications/updateNotificationPreference"
    static let CANCEL_EVENT = "/evolve-api/public/app/v3/user/cancelEvent"
    static let UPDATE_DEVICE_TOKEN = "/evolve-api/public/app/v3/notifications/updateDeviceToken"
    
    
    //Mark Profile
    static let MEMBERSHIP_LIST = "/evolve-api/public/app/v3/membership/list"
    static let MEMBERSHIP_DETAILS = "/evolve-api/public/app/v3/membership/details"
    static let USER_MEMBERSHIP = "/evolve-api/public/app/v3/membership/userMembership"
    static let UPDATE_PROFILE = "/evolve-api/public/app/v3/user/updateProfile"
    static let UPDATE_PROFILE_IMAGE = "/evolve-api/public/app/v3/user/profilepic"
    
}
