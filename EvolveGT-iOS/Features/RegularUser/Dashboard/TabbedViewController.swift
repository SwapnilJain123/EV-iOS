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
     
    func enableSlideMenu(){
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
}
