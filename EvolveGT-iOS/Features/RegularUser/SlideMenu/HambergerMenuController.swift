//
//  SlideMenuController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 10/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import SideMenuSwift

class HambergerMenuController: ETViewController {
    
    
    
    @IBOutlet weak var slidingMenuView: UITableView!
    
    var menuItems = SlideMenuItem.getllItems()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(!(AppEngine.sharedInstance.currentUser?.isAdminOrCoach() ?? false)){
            menuItems.removeAll{$0.tag == SlideMenuItem.TAG_SWITCH_DASHBOARD}
        }
        slidingMenuView.dataSource = self
        slidingMenuView.delegate = self
        self.ext.hideNavbar()
    }
    
    func refreshSideMenu(){
        self.slidingMenuView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
        self.refreshSideMenu()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    func pushViewController(_ controller: UIViewController) {
        guard let rootNavigationController = self.ext.getAppWindow()?.rootViewController as? UINavigationController else { return }
        guard let sideMenuController = rootNavigationController.viewControllers.first as? SideMenuController else { return }
        sideMenuController.hideMenu { completed in
            guard completed else { return }
            rootNavigationController.pushViewController(controller, animated: true)
        }
    }
    
    
}
extension HambergerMenuController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"SideMenuCell",for: indexPath) as! SlideMenuCell
        cell.titleLbl.text = menuItems[indexPath.row].title
        let icon = AppEngine.sharedInstance.isEvApp() ? menuItems[indexPath.row].evIcon : menuItems[indexPath.row].motoIcon
        cell.iconImgView.image =  UIImage(named:icon)
        
        return cell
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.sideMenuController?.hideMenu()
        
        handleMenuItem(tag : menuItems[indexPath.row].tag)
        
    }
    
    func switchToAdminDashboard(){
        
    }
    
    func handleMenuItem(tag: Int){
        switch tag {
        case SlideMenuItem.TAG_CREDIT_HISTORY:
            let vc = self.ext.getViewController(storyBoard: "CreditHistory", VCIdentifier: "CreditHistoryViewController")
            pushViewController(vc)
        case SlideMenuItem.TAG_PAST_EVENTS:
            let vc = EnrolledEventsSlidingTabController()
            vc.selectedIndex = EnrolledEventsSlidingTabController.TAB_PAST
            self.ext.pushViewController(viewController: vc)
            
        case SlideMenuItem.TAG_UPCOMING_EVENTS:
            let vc = EnrolledEventsSlidingTabController()
            vc.selectedIndex = EnrolledEventsSlidingTabController.TAB_UPCOMING
            self.ext.pushViewController(viewController: vc)
        case SlideMenuItem.TAG_SWITCH_DASHBOARD:
            self.dashboardManager.switchToAdminDashboard()
            
        case SlideMenuItem.TAG_LOG_OUT:
            self.dashboardManager.logout()
        case SlideMenuItem.TAG_SETTINGS:
            self.ext.pushViewController(storyBoard: "Settings", VCIdentifier: "SettingsVC")
        case SlideMenuItem.TAG_CHANGE_PASSWORD:
            self.ext.pushViewController(storyBoard: "ChangePassword", VCIdentifier: "changePasswordVC")
        case SlideMenuItem.TAG_ABOUT_US:
            self.ext.pushViewController(storyBoard: "AboutUs", VCIdentifier: "aboutUsVC")
            
        case SlideMenuItem.TAG_MEMBERSHIP:
            self.ext.pushViewController(storyBoard: "Membership", VCIdentifier: "MembershipVC")
        case SlideMenuItem.TAG_MY_PROFILE:
            self.ext.pushViewController(storyBoard: "Profile", VCIdentifier: "ProfileController")
        case SlideMenuItem.TAG_E_WAIVER:
            self.ext.pushViewController(storyBoard: "E-Waiver", VCIdentifier: "E-WaiverVC")
            
            
        default:
            break
        }
    }
}
