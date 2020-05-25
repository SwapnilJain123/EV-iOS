//
//  ShopTabViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import XLPagerTabStrip


class ShopTabViewController :ButtonBarPagerTabStripViewController{
    
    var categories =  [ProductCategory]()
    var source = ""
    
    let interactor = ShopsInteractor()
    override func viewDidLoad() {
        
        let appColor = UIColor.getAppThemeColor()
        settings.style.buttonBarBackgroundColor = appColor
        settings.style.buttonBarItemBackgroundColor = appColor
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 15)
        settings.style.selectedBarHeight = 4.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?,
            progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            
            guard changeCurrentIndex == true else { return }
            
            oldCell?.label.textColor = .darkGray
            newCell?.label.textColor = .white
            
        }
        
         
        super.viewDidLoad()
        self.title = source
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = source
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController]{
        var controllers = [ProductListController]()
        
       
        for category in categories{
            let productListVC = self.ext.getViewController(storyBoard: "Shop", VCIdentifier: "ProductList") as! ProductListController
            productListVC.category = category
            productListVC.source = source
            controllers.append(productListVC)
        }
        
        
        return controllers
    }
}

