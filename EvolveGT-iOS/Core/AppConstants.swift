//
//  AppConstants.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit


let KEY_USER = "saved_user"
let KEY_AUTH_TOKEN = "auth_token"

struct ScreenTitle{
    
    //Mark: Admin Screen
    static let TITLE_EVENTS = "Events"
    static let TITLE_EVENTS_USERS = "Event Participants"
}

struct ScreenSize{
       
       static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
       static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
       static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
       static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
   }

struct DeviceType
{
    
    static let IS_IPHONE_5s = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    
    static let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    
    static let IS_IPHONE_6p = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    
    static let IS_IPHONE_X = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH >= 812.0
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad

    
}
