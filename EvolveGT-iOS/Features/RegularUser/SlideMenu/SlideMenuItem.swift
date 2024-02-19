//
//  SlideMenuItem.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 10/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct SlideMenuItem{
    
    static let TAG_HOME = 1
    static let TAG_UPCOMING_EVENTS = 2
    static let TAG_PAST_EVENTS = 3
    
    static let TAG_CREDIT_HISTORY = 4
    static let TAG_MEMBERSHIP = 5
    static let TAG_MY_PROFILE = 6
    static let TAG_CHANGE_PASSWORD = 7
    static let TAG_SETTINGS = 8
    static let TAG_ABOUT_US = 9
    static let TAG_SWITCH_DASHBOARD = 10
    static let TAG_Delete_Me = 15

    static let TAG_LOG_OUT = 11
    static let TAG_E_WAIVER = 12
    static let TAG_REFER_FRIEND = 13
    static let TAG_TRANSFER_CREDIT = 14
    var title = ""
    var evIcon = ""
    var motoIcon = ""
    var tag = 0
    
    init(){
        
    }
    init(_ title: String, _ evIcon : String, _ motoIcon : String, _ tag: Int ){
        self.title = title
        self.evIcon = evIcon
        self.motoIcon = motoIcon
        self.tag = tag
    }
    public static func getllItems() -> [SlideMenuItem]{
        let empty = SlideMenuItem()
        
        let home = SlideMenuItem("Home", "homesideMenu", "mato_slider_home", TAG_HOME)
        
        let upcomingEvents = SlideMenuItem("Upcoming Events", "upcoming_events_a", "moto_upcoming_events",TAG_UPCOMING_EVENTS)
        let pastEvents = SlideMenuItem("Past Events", "past_events_a","moto_past_events", TAG_PAST_EVENTS)
        let creditHistory = SlideMenuItem("Credit History", "credit_history","moto_slider_credit_hitory", TAG_CREDIT_HISTORY)
        
        let membership = SlideMenuItem("Membership", "membership","moto_slider_membership", TAG_MEMBERSHIP)
        let myProfile = SlideMenuItem("My Profile", "my_profile", "moto_slider_profile",TAG_MY_PROFILE)
        
        let changePassword = SlideMenuItem("Change Password", "change password", "moto_slider_change_password",TAG_CHANGE_PASSWORD)
        let settings = SlideMenuItem("Settings", "settings", "moto_slider_settings",TAG_SETTINGS)
        let aboutUs = SlideMenuItem("About Us", "aboutUs", "mato_slider_about_us",TAG_ABOUT_US)
        
        let switchDashboard = SlideMenuItem("Switch Dashboard", "SwictUserGreen","moto_slider_switch_dashboard", TAG_SWITCH_DASHBOARD)
        
        let waiver = SlideMenuItem("E-Waiver", "e-waiver", "e-waiver-moto",TAG_E_WAIVER)
        
        let transferCredit = SlideMenuItem("Transfer Credit", "credit-transfer-ev", "credit-transfer-moto",TAG_TRANSFER_CREDIT)
        
        let deleteMe = SlideMenuItem("Delete Account", "DeleteMe", "DeleteMe",TAG_Delete_Me)

        let logout = SlideMenuItem("Logout", "logoutGreen", "mato_slider_logout",TAG_LOG_OUT)
        
         
//        let referFriend = SlideMenuItem("Refer a friend", "refer_a_friend", "refer_a_friend_moto",TAG_REFER_FRIEND)
//
        return [empty, home, upcomingEvents, pastEvents, creditHistory, membership, myProfile, changePassword, settings, aboutUs, switchDashboard, waiver,transferCredit, deleteMe, logout]///, referFriend
    }
}
