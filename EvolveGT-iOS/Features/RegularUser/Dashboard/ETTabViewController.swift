//
//  ETTabViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 04/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
class ETTabViewController: UITabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ext.setNavigationBackgroundColor(color: .getAppThemeColor())
        self.ext.showNavbar()
        self.ext.hideBackButton()
        
        tabBar.barTintColor = UIColor.black
        
       
    }
    
    
    
}
