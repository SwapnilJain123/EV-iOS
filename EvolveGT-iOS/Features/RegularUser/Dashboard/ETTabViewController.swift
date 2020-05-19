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



class ETTabViewController: UITabBarController, UITabBarControllerDelegate{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ext.setNavigationBackgroundColor(color: .getAppThemeColor())
        self.ext.showNavbar()
        self.ext.hideBackButton()
        
        tabBar.barTintColor = UIColor.black
        self.delegate = self
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
}
