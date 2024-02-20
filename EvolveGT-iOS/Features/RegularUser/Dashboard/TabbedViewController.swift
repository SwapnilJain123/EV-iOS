//
//  TabbedViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 10/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import SideMenuSwift

class TabbedViewController: ETViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavbarControls()
        
        if AppEngine.sharedInstance.isUserLoggedIn(){
            enableSlideMenu()
        }
        
    }
    
    func addNavBarControls() -> [UIBarButtonItem]?{
        return nil
    }
    
    private func setNavbarControls(){
        
        
                   var switcIcon = UIImage(named: "switch_moto")
                   if !AppEngine.sharedInstance.isEvApp(){
                       switcIcon = UIImage(named: "switch_ev")
                   }
        
                   let switchAppMode = UIBarButtonItem(image: switcIcon,
                                                       style: .plain,
                                                       target: self,
                                                       action: #selector(self.switchAppTheme))
        
        
        let switchDashboard = UIBarButtonItem(image: #imageLiteral(resourceName: "SwictUserWhite"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(self.switchDashboard))
        
        var navbarControls = [UIBarButtonItem]()
        if AppEngine.sharedInstance.isUserLoggedIn(){
            if(AppConstants.APP_MODE_SWITCH_ENABLED){
//                navbarControls.append(switchAppMode)
            }
            if(AppEngine.sharedInstance.currentUser?.hasAdminPrevilege ?? false && AppConstants.DASHBOARD_SWITCH_ENABLED){
                navbarControls.append(switchDashboard)
            }
        }
        
        let additionalControls = addNavBarControls()
        if additionalControls == nil{
            self.navigationItem.rightBarButtonItems = navbarControls
        }else{
            navbarControls.append(contentsOf: additionalControls!)
            self.navigationItem.rightBarButtonItems = navbarControls
        }
    }
    
    private func enableSlideMenu() {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "HMenu"), for: UIControl.State.normal)
        button.addTarget(self, action:#selector(self.menuBtnClicked) , for: .touchUpInside)
        button.frame =  CGRect.init(x: 0, y: 0, width: 45, height: 45)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItems = [barButton]
    }
    
    @objc func menuBtnClicked(){
        self.sideMenuController?.revealMenu()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.ext.showBackButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ext.showNavbar()
        
        if AppEngine.sharedInstance.isUserLoggedIn(){
            self.ext.hideBackButton()
        }else{
             self.ext.showBackButton()
        }
    }
    
   
    @objc func switchAppTheme(){
        self.dashboardManager.switchAppMode()
    }
    
    @objc func switchDashboard(){
           self.dashboardManager.switchToAdminDashboard()
       }
    
    override  func didChangeAppTheme() {
        setNavbarControls()
        getTabBarController()?.didChangeAppTheme()
    }
    
    func recreateNavbar(){
        setNavbarControls()
    }
    
    func getTabBarController() -> ETTabViewController?{
        self.navigationController?.tabBarController as? ETTabViewController
    }
    @objc func didSwitchTab(){
        
    }
    
    override func updateCartBadge(count: Int) {
        Log.i("Updating Badge - \(count)")
        getTabBarController()?.updateCartBadgeCount(count: count)
    }
}
