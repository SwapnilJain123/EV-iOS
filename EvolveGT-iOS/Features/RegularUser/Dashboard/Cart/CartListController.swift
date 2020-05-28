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
        
        btnCheckout.applyColorTheme()
        labelTotal.textColor = .getAppThemeColor()
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor.fetchCartList()
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
       let vc =  self.ext.getViewController(storyBoard: "Cart", VCIdentifier: "ReviewCartVC") as! ReviewCartController
        vc.interactor = self.interactor
        vc.cartItems = self.cartItems
        self.ext.pushViewController(viewController: vc)
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
    
    
}
extension CartListController: CartCellDelegate{
    func deleteCartItem(cartItem: CartItem) {
        interactor.removeFromCart(cartItem: cartItem)
    }
    
    
}
