//
//  ShopSlidingTabController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 30/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

class ShopSlidingTabController: ETViewController{
    
    private let slidingTabController = UISimpleSlidingTabController()
    
    var categories =  [ProductCategory]()
    var source = ""
    
    let interactor = ShopsInteractor()
    
    private func setupUI(){
        
        // navigation
        navigationItem.title = getScreenTitle()
        
        view.backgroundColor = .clear
        view.addSubview(slidingTabController.view)
        
        provideViewControllers()
        
        slidingTabController.setHeaderActiveColor(color: .white)
        slidingTabController.setHeaderInActiveColor(color: .lightText)
        slidingTabController.setHeaderBackgroundColor(color: .getAppThemeColor())
        slidingTabController.setCurrentPosition(position: 0)
        slidingTabController.setStyle(style: .flexible)
        slidingTabController.build()
    }
    override func getScreenTitle() -> String{
        source
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = getScreenTitle()
        setupUI()
    }
    func provideViewControllers(){
        for category in categories{
            let productListVC = self.ext.getViewController(storyBoard: "Shop", VCIdentifier: "ProductList") as! ProductListController
            productListVC.category = category
            productListVC.source = source
            productListVC.holderVC = self
            slidingTabController.addItem(item: productListVC, title: category.title ?? "")
        }
    }
}
