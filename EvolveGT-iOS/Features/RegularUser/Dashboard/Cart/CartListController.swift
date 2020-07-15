//
//  CartListController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 26/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
class CartListController : TabbedViewController, CartListDelegate{
    
    @IBOutlet weak var guestMessage: UILabel!
    let interactor = CartInteractor()
    var cartItems = [CartItem]()
    
    
    @IBOutlet weak var outOfStockLabel: UILabel!
    @IBOutlet weak var btnCheckout: UIButton!
    @IBOutlet weak var cartListView: UITableView!
    @IBOutlet weak var labelTotal: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor.delegate = self
        interactor.cartListDelegate = self
        cartListView.dataSource = self
        cartListView.delegate = self
        
       
        labelTotal.textColor = .getAppThemeColor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         btnCheckout.applyColorTheme()
        labelTotal.textColor = .getAppThemeColor()
        totalPrice(total: 0)
        outOfStockLabel.isHidden = true
        
        if AppEngine.sharedInstance.isUserLoggedIn(){
            guestMessage.isHidden = true
            interactor.fetchCartList()
        }else{
            guestMessage.isHidden = false
            guestMessage.text = MessageConstants.guestCart
            btnCheckout.setTitle("Login", for: .normal)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cartItems.removeAll()
        cartListView.reloadData()
    }
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_CART
    }
    func didFetchCartList(cartItems: [CartItem]) {
        self.cartItems = cartItems
        cartListView.reloadData()
    }
    override func didChangeAppTheme() {
        super.didChangeAppTheme()
        btnCheckout.applyColorTheme()
        labelTotal.textColor = .getAppThemeColor()
        cartListView.reloadData()
    }
    
    func totalPrice(total: Double) {
        labelTotal.text = String(total).formatToAmount()
    }
    
    func hasOutOfStockItems(outOfStock: Bool) {
        btnCheckout.isEnabled = !outOfStock
        
        if outOfStock{
            outOfStockLabel.text = ErrorMessages.hasOutOfStockItems
        }else{
            outOfStockLabel.text = ""
        }
    }
    @IBAction func didPressCheckoutButton(_ sender: Any) {
        if !AppEngine.sharedInstance.isUserLoggedIn(){
            self.dashboardManager.switchToLoginPage()
        }else{
            let vc =  self.ext.getViewController(storyBoard: "Cart", VCIdentifier: "ReviewCartVC") as! ReviewCartController
            vc.interactor = self.interactor
            vc.cartItems = self.cartItems
            self.ext.pushViewController(viewController: vc)
        }
    }
}
extension CartListController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = BaseCartCell()
        let cartItem = cartItems[indexPath.row]
        
        if !cartItem.tertiaryProperty.isEmpty(){
            cell = tableView.dequeueReusableCell(withIdentifier: CartAllPropertiesCell.identifier, for: indexPath) as! CartAllPropertiesCell
        }else  if !cartItem.secondaryProperty.isEmpty(){
            cell = tableView.dequeueReusableCell(withIdentifier: Cart3PropertiesCell.identifier, for: indexPath) as! Cart3PropertiesCell
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: Cart2PropertiesCell.identifier, for: indexPath) as! Cart2PropertiesCell
        }
        
        cell.cartItem = cartItem
        cell.delegate = self
        cell.showData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCart = cartItems[indexPath.row]
        switch selectedCart.source {
        case .archie:
            let vc = self.ext.getViewController(storyBoard: "ArchieCard", VCIdentifier: "archieCardDetailsVC") as! ArchieCardDetailsViewController
            vc.slug = selectedCart.slug ?? ""
            vc.selectedArchieTitle = selectedCart.title ?? ""
            self.ext.pushViewController(viewController: vc)
            
        case .event:
            let vc = self.ext.getViewController(storyBoard: "Events", VCIdentifier: "EventDetailsVC") as! EventDetailsController
            vc.eventSlug = selectedCart.slug ?? ""
            vc.eventTitle = selectedCart.title ?? ""
            if selectedCart.isMotoEvent && !AppEngine.sharedInstance.isEvApp(){
                vc.isMotoEvent = false
                self.ext.pushViewController(viewController: vc)
                
            }else if !selectedCart.isMotoEvent && AppEngine.sharedInstance.isEvApp(){
                vc.isMotoEvent = true
                self.ext.pushViewController(viewController: vc)
            }
        case .giftcard:
            let vc = self.ext.getViewController(storyBoard: "GiftCard", VCIdentifier: "giftCardDetailsVC") as! GiftCardDetailsViewController
            vc.slug = selectedCart.slug ?? ""
            vc.screenTitle = selectedCart.title ?? ""
            self.ext.pushViewController(viewController: vc)
        case .rentals, .training:
            if AppEngine.sharedInstance.isEvApp(){
                let vc = self.ext.getViewController(storyBoard: "Events", VCIdentifier: "EventDetailsVC") as! EventDetailsController
                vc.eventSlug = selectedCart.parentSlug ?? ""
                vc.eventTitle = selectedCart.parentTitle ?? ""
                vc.isMotoEvent = false
                self.ext.pushViewController(viewController: vc)
            }
        case .transponder:
            if !AppEngine.sharedInstance.isEvApp(){
                let vc = self.ext.getViewController(storyBoard: "Events", VCIdentifier: "EventDetailsVC") as! EventDetailsController
                vc.eventSlug = selectedCart.parentSlug ?? ""
                vc.eventTitle = selectedCart.parentTitle ?? ""
                vc.isMotoEvent = true
                self.ext.pushViewController(viewController: vc)
            }
        case .membership:
            let vc = self.ext.getViewController(storyBoard: "Membership", VCIdentifier: "membershipDetailsVC") as! MembershipDetailsViewController
            vc.slug = selectedCart.slug ?? ""
            vc.membershipTitle = selectedCart.title ?? ""
            self.ext.pushViewController(viewController: vc)
        case .product:
            let vc = self.ext.getViewController(storyBoard: "Shop", VCIdentifier: "ProductDetailsVC") as! ProductDetailsController
            vc.productSlug = selectedCart.slug ?? ""
            vc.productName = selectedCart.title ?? ""
            self.ext.pushViewController(viewController: vc)
        default:
            Log.d("Item Click ignored")
        }
        
        
    }
}
extension CartListController: CartCellDelegate{
    func deleteCartItem(cartItem: CartItem) {
        interactor.removeFromCart(cartItem: cartItem)
    }
    
    
}
