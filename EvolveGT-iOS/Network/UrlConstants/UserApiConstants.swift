//
//  LoginUrlConstants.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct UserApiConstants{
    
    static let LOGIN = "user/auth"
    static let FORGOT_PASSWORD = "user/forgotPassword"
    static let CHANGE_PASSWORD = "user/changePassword"
    static let USER_DETAILS = "user/details"
    static let USER_EVENT_HISTORY = "user/allEvents"
    static let USER_CREDIT_HISTORY = "user/creditHistory"
    
    //Mark: Notifications
    static let NOTIFICATION_TYPES = "notifications/types"
    static let UPDATE_NOTIFICATION_PREF = "notifications/updateNotificationPreference"
    static let CANCEL_EVENT = "user/cancelEvent"
    static let UPDATE_DEVICE_TOKEN = "notifications/updateDeviceToken"
    
    
    //Mark: Profile
    static let MEMBERSHIP_LIST = "membership/list"
    static let MEMBERSHIP_DETAILS = "membership/details"
    static let USER_MEMBERSHIP = "membership/userMembership"
    static let UPDATE_PROFILE = "user/updateProfile"
    static let UPDATE_PROFILE_IMAGE = "user/profilepic"
    
}
