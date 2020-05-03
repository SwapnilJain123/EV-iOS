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
    
    @IBOutlet weak var actionsTableView: UITableView!
    
    let menuItems = GuestAction.getGuestMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ext.showBackButton()
        self.ext.setScreenTitle(title: "Guest")
        
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
            Log.d("Launch Events")
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
class GuestActionCell : UITableViewCell{
    
  
    var leftMenu : GuestAction? = nil
    var rightMenu : GuestAction? = nil
    
    @IBOutlet weak var leftActionView: UIView!
    @IBOutlet weak var rightActionView: UIView!
    
    @IBOutlet weak var leftActionIcon: UIImageView!
    
    
    @IBOutlet weak var leftActionName: UILabel!
    
    @IBOutlet weak var rightActionIcon: UIImageView!
    
    
    @IBOutlet weak var rightActionName: UILabel!
    
    
  
    @IBAction func didPressRightAction(_ sender: Any) {
        if let action = rightMenu?.action{
            action()
        }
    }
    
    
    @IBAction func didPressLeftAction(_ sender: Any) {
        if let action = leftMenu?.action{
            action()
        }
    }
    
    
    func setActionView(left : GuestAction, right: GuestAction){
        self.leftMenu = left
        self.rightMenu = right
        leftActionIcon.image = UIImage(named: left.actionIcon)
        leftActionName.text = left.actionName
        
        rightActionIcon.image = UIImage(named: right.actionIcon)
        rightActionName.text = right.actionName
        
        leftActionView.setCardView()
        rightActionView.setCardView()
    }
    
}
extension GuestViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GuestActionCell",
                                                 for: indexPath) as! GuestActionCell
       
        let  row = indexPath.row * 2
        cell.setActionView(left: menuItems[row], right: menuItems[row + 1] )
        return cell
    }
    
    
}
