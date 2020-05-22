//
//  ShopsInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 21/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation

protocol ShopsMenuDelegate {
    func launchArchieCardsView()
     func launchGiftCardsView()
     func launchGearView()
     func launchRentalsView()
}
class ShopsInteractor : BaseInteractor{
    
    var delegate : ShopsMenuDelegate?
     func getMenuItems() -> [ShopsMenu]{
        var guestMenu = [ShopsMenu]()
        
        var menuArchie = ShopsMenu()
        menuArchie.actionName = "Archie Cards"
        menuArchie.actionIcon = "archie_cards"
        menuArchie.action = {
            Log.d("Launch Archies")
            self.delegate?.launchArchieCardsView()
        }
        guestMenu.append(menuArchie)
        
        var menuRental = ShopsMenu()
        menuRental.actionName = "Rentals"
        menuRental.actionIcon = "ic_shop_rentals"
        menuRental.action = {
            Log.d("Launch Rentals")
            self.delegate?.launchRentalsView()
        }
        guestMenu.append(menuRental)
        
        var menuGifts = ShopsMenu()
        menuGifts.actionName = "Gifts"
        menuGifts.actionIcon = "gifts"
        menuGifts.action = {
            Log.d("Launch Gifts")
            self.delegate?.launchGiftCardsView()
        }
        guestMenu.append(menuGifts)
        var menuGear = ShopsMenu()
        menuGear.actionName = "GEAR"
        menuGear.actionIcon = "gear"
        menuGear.action = {
            Log.d("Launch Gear")
            self.delegate?.launchGearView()
        }
        guestMenu.append(menuGear)
        
        
        return guestMenu
    }
}

struct ShopsMenu{
    var actionName = ""
    var actionIcon = ""
    var action : (() -> Void)? = nil
    
    
}
