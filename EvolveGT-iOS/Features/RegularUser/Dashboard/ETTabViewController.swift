//
//  ETTabViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 04/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import SideMenuSwift



class ETTabViewController: UITabBarController, UITabBarControllerDelegate, AgreementAcceptanceDelegate{
    
    var notificationPayload : [AnyHashable: Any]?
    
    func requestToAcceptPolicies(agreement: AgreementStatus) {
        let vc = self.ext.getViewController(storyBoard: "Home", VCIdentifier: "PolicyVC")
        self.dashboardManager.pushToNewNavigationController(viewController: vc)
    }
    
    func userHasAcceptedConditions() {
        //ignored
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        styleTabBar()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ext.setNavigationBackgroundColor(color: .getAppThemeColor())
        self.ext.showNavbar()
        self.ext.hideBackButton()
        
        
        self.delegate = self
        
        let interactor = HomeDataInteractor()
        interactor.agreementStatusDelegate = self
        interactor.verifyUserAgreedTerms()
        interactor.updateDeviceToken()
        
        if notificationPayload != nil{
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                self.processNotficationPayload()
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCartBadgeCount(count: AppEngine.sharedInstance.cartListCount)
    }
    func processNotficationPayload(){
        let pushType = notificationPayload!["type"] as! String
        
        if pushType == "event"{
             let eventSlug = notificationPayload!["event_slug"] as? String
            let eventTitle = notificationPayload!["event_title"] as? String
            let isMotoEvent = notificationPayload!["isMotoEvent"] as? String
            
            let eventDetailsVC = self.ext.getViewController(storyBoard: "Events", VCIdentifier: "EventDetailsVC") as! EventDetailsController
            eventDetailsVC.eventSlug = eventSlug ?? ""
            eventDetailsVC.eventTitle = eventTitle ?? ""
            eventDetailsVC.isMotoEvent = "true" == isMotoEvent?.lowercased()
            
            if eventDetailsVC.isMotoEvent != AppEngine.sharedInstance.isEvApp(){
                let eventTabNavController = self.viewControllers?[1] as! UINavigationController
                eventTabNavController.pushViewController(eventDetailsVC, animated: false)
                self.selectedViewController = self.viewControllers?[1]
            }
            
        }else if pushType == "web"{
             let url = notificationPayload!["url"] as! String
            self.ext.openLink(url)
        }
    }
    func enableSlideMenu(){
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "HMenu"), for: UIControl.State.normal)
        button.addTarget(self, action:#selector(self.menuBtnClicked) , for: .touchUpInside)
        button.frame =  CGRect.init(x: 0, y: 0, width: 45, height: 45)
        let barButton = UIBarButtonItem(customView: button)
        self.getCurrentVC()?.navigationItem.leftBarButtonItems = [barButton]
    }
    
    @objc func menuBtnClicked(){
        let index = self.tabBarController!.selectedIndex
        self.tabBarController!.viewControllers?[index].sideMenuController?.revealMenu()
    }
    func getCurrentVC ()-> ETViewController?{
        let index = self.tabBarController?.selectedIndex ?? -1
        if index != -1{
            return self.tabBarController!.viewControllers![index] as? ETViewController
        }else{
            return nil
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if let displayedVC = viewController.presentedViewController as? TabbedViewController{
            displayedVC.didSwitchTab()
        }
        
    }
    
    func styleTabBar(){
        if AppEngine.sharedInstance.isEvApp(){
            self.tabBar.barTintColor = .getEVTabBackgroundGray()
            self.tabBar.tintColor = .getEvColor()
            self.tabBar.unselectedItemTintColor = .lightText
        }else{
            self.tabBar.barTintColor = .getMotoColor()
            self.tabBar.tintColor = .white
            self.tabBar.unselectedItemTintColor = .lightGray
            
        }
        self.tabBar.isTranslucent = false
    }
    override func didChangeAppTheme() {
        Log.d("App Theme Changed")
        styleTabBar()
    }
    
    func updateCartBadgeCount(count: Int){
        if let tabItems = self.tabBar.items{
            // In this case we want to modify the badge number of the third tab:
            let tabItem = tabItems[3]
            if count > 0{
                tabItem.badgeValue = String(count)
            }else{
                tabItem.badgeValue = nil
            }
        }
    }
}
