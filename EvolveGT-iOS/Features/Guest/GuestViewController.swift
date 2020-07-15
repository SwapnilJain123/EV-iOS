//
//  GuestViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 03/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

class GuestViewController : ETViewController{
    
    var categoryList = [ProductCategory]()
    
    let interactor = ShopsInteractor()
    
    @IBOutlet weak var actionsTableView: UITableView!
    
    let menuItems = GuestAction.getGuestMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ext.showNavbar()
        self.ext.showBackButton()
        self.ext.setScreenTitle(title: "Guest")
        
        interactor.viewDelegate = self
        interactor.categoryDelegate = self
        interactor.fetchCategoryList()
        
        actionsTableView.dataSource = self
    }
    
    
}

struct  GuestAction{
    var actionName = ""
    var actionIcon = ""
    var action : (() -> Void)? = nil
    
    static func getGuestMenu() -> [GuestAction]{
        var guestMenu = [GuestAction]()
        
        var menuEvents = GuestAction()
        menuEvents.actionName = "Events"
        menuEvents.actionIcon = "ic_shop_events"
        menuEvents.action = {
            
            
        }
        guestMenu.append(menuEvents)
        
        var menuGear = GuestAction()
        menuGear.actionName = "GEAR"
        menuGear.actionIcon = "gear"
        menuGear.action = {
            Log.d("Launch Gear")
        }
        guestMenu.append(menuGear)
        
        var menuGifts = GuestAction()
        menuGifts.actionName = "Gifts"
        menuGifts.actionIcon = "gifts"
        menuGifts.action = {
            Log.d("Launch Gifts")
        }
        guestMenu.append(menuGifts)
        
        var menuArchie = GuestAction()
        menuArchie.actionName = "Archie Cards"
        menuArchie.actionIcon = "archie_cards"
        menuArchie.action = {
            Log.d("Launch Archies")
        }
        guestMenu.append(menuArchie)
        
        var menuRental = GuestAction()
        menuRental.actionName = "Rentals"
        menuRental.actionIcon = "ic_shop_rentals"
        menuRental.action = {
            Log.d("Launch Rentals")
        }
        guestMenu.append(menuRental)
        
        var menuCart = GuestAction()
        menuCart.actionName = "CART"
        menuCart.actionIcon = "cart"
        menuCart.action = {
            Log.d("Launch Cart")
        }
        guestMenu.append(menuCart)
        
        
        
        return guestMenu
    }
}

protocol GuestActionCellDelegate{
    func didPressMenu(indexPath: IndexPath, isLeft: Bool)
}
class GuestActionCell : UITableViewCell{
    
    var delegate : GuestActionCellDelegate?
    var leftMenu : GuestAction? = nil
    var rightMenu : GuestAction? = nil
    var indexPath: IndexPath?
    
    @IBOutlet weak var leftActionView: UIView!
    @IBOutlet weak var rightActionView: UIView!
    
    @IBOutlet weak var leftActionIcon: UIImageView!
    
    
    @IBOutlet weak var leftActionName: UILabel!
    
    @IBOutlet weak var rightActionIcon: UIImageView!
    
    
    @IBOutlet weak var rightActionName: UILabel!
    
    
    
    @IBAction func didPressRightAction(_ sender: Any) {
        delegate?.didPressMenu(indexPath: self.indexPath!, isLeft: false)
    }
    
    
    @IBAction func didPressLeftAction(_ sender: Any) {
        delegate?.didPressMenu(indexPath: self.indexPath!, isLeft: true)
    }
    
    
    func setActionView(indexPath : IndexPath, left : GuestAction, right: GuestAction){
        self.leftMenu = left
        self.rightMenu = right
        self.indexPath = indexPath
        leftActionIcon.image = UIImage(named: left.actionIcon)
        leftActionName.text = left.actionName.uppercased()
        
        rightActionIcon.image = UIImage(named: right.actionIcon)
        rightActionName.text = right.actionName.uppercased()
        
        leftActionView.setCardView()
        rightActionView.setCardView()
    }
    
}
extension GuestViewController: UITableViewDataSource, GuestActionCellDelegate{
    
    func didPressMenu(indexPath: IndexPath, isLeft: Bool) {
        if indexPath.row == 0{
            if isLeft{
                self.ext.pushViewController(storyBoard: "Events", VCIdentifier: "EventListVC")
            }else{
                launchGear()
            }
        }else  if indexPath.row == 1{
            if isLeft{
                self.ext.pushViewController(storyBoard: "GiftCard", VCIdentifier: "giftCardVC")
            }else{
                self.ext.pushViewController(storyBoard: "ArchieCard", VCIdentifier: "archieCardVC")
            }
        }else  if indexPath.row == 2{
            if isLeft{
                launchRentals()
            }else{
                launchCart()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GuestActionCell",
                                                 for: indexPath) as! GuestActionCell
        
        let  row = indexPath.row * 2
        cell.setActionView(indexPath: indexPath, left: menuItems[row], right: menuItems[row + 1] )
        cell.delegate = self
        return cell
    }
    
    func launchCart(){
        self.ext.pushViewController(storyBoard: "Cart", VCIdentifier: "CartList")
    }
    func launchRentals(){
        if categoryList.count == 0{
                    self.ext.showErrorToast(message: ErrorMessages.genericError, handler: nil)
                    self.interactor.fetchCategoryList()
                }else{
        //            let rentalsVC = self.ext.getViewController(storyBoard: "Shop", VCIdentifier: "ShopTabbedVC") as! ShopTabViewController
                    
                    let rentalsVC = ShopSlidingTabController()
                    for category in categoryList where category.isRentals{
                        if category.children?.count ?? 0 > 0{
                            rentalsVC.categories = category.children!
                        }
                    }
                    rentalsVC.source = "Rentals"
                    if rentalsVC.categories.count > 1{
                        self.ext.pushViewController(viewController: rentalsVC)
                    }else if rentalsVC.categories.count > 0{
                        openProductListController(category: rentalsVC.categories[0], source: rentalsVC.source)
                    }else{
                        self.ext.showErrorToast(message: ErrorMessages.genericError, handler: nil)
                    }
                   
                }
    }
    func launchGear(){
        if categoryList.count == 0{
            self.ext.showErrorToast(message: ErrorMessages.genericError, handler: nil)
            self.interactor.fetchCategoryList()
        }else{
            //            let gearVC = self.ext.getViewController(storyBoard: "Shop", VCIdentifier: "ShopTabbedVC") as! ShopTabViewController
            let gearVC = ShopSlidingTabController()
            for category in categoryList where category.isGear{
                if category.children?.count ?? 0 > 0{
                    gearVC.categories = category.children!
                }
            }
            gearVC.source = "Gear"
            
            if gearVC.categories.count > 1{
                self.ext.pushViewController(viewController: gearVC)
            }else if gearVC.categories.count > 0{
                openProductListController(category: gearVC.categories[0], source: gearVC.source)
            }else{
                self.ext.showErrorToast(message: ErrorMessages.genericError, handler: nil)
            }
            
        }
    }
    
    func openProductListController(category : ProductCategory, source: String){
        let productListVC = self.ext.getViewController(storyBoard: "Shop", VCIdentifier: "ProductList") as! ProductListController
        productListVC.category = category
        productListVC.source = source
        self.ext.pushViewController(viewController: productListVC)
        
    }
}
extension GuestViewController : CategoryViewDelegate{
    func didFetchCategories(categories: [ProductCategory]) {
        categoryList = categories
    }
    
    override func showEmptyPageError(message: String) {
        //bypass full page error
        self.ext.showErrorToast(message: message, handler: nil)
    }
    
}
