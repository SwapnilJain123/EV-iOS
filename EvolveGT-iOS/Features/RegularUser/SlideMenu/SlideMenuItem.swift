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
    static let TAG_LOG_OUT = 11
    
    var title = ""
    var  icon = ""
    var tag = 0
    
    init(){
        
    }
    init(_ title: String, _ icon : String, _ tag: Int ){
        self.title = title
        self.icon = icon
        self.tag = tag
    }
    public static func getllItems() -> [SlideMenuItem]{
        let empty = SlideMenuItem()
        
        let home = SlideMenuItem("Home", "homesideMenu", TAG_HOME)
        let upcomingEvents = SlideMenuItem("Upcoming Events", "upcoming_events_a", TAG_UPCOMING_EVENTS)
        
        let pastEvents = SlideMenuItem("Past Events", "past_events_a", TAG_PAST_EVENTS)
        let creditHistory = SlideMenuItem("Credit History", "credit_history", TAG_CREDIT_HISTORY)
        let membership = SlideMenuItem("Membership", "membership", TAG_UPCOMING_EVENTS)
        let myProfile = SlideMenuItem("My Profile", "my_profile", TAG_MY_PROFILE)
        let changePassword = SlideMenuItem("Change Password", "change password", TAG_CHANGE_PASSWORD)
        let settings = SlideMenuItem("Settings", "settings", TAG_SETTINGS)
        let aboutUs = SlideMenuItem("About Us", "aboutUs", TAG_ABOUT_US)
        let switchDashboard = SlideMenuItem("Switch Dashboard", "SwictUserGreen", TAG_SWITCH_DASHBOARD)
        let logout = SlideMenuItem("Logout", "logoutGreen", TAG_LOG_OUT)
        
        return [empty, home, upcomingEvents, pastEvents, creditHistory, membership, myProfile, changePassword, settings, aboutUs, switchDashboard, logout]
    }
}
