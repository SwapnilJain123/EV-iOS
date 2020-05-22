//
//  ShopViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 21/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
class ShopViewController : TabbedViewController{
    
    @IBOutlet weak var shopsBanner: UIImageView!
    
    @IBOutlet weak var menuArchieCardBackground: UIView!
    @IBOutlet weak var menuRentalsBackground: UIView!
    @IBOutlet weak var menuGiftsBackground: UIView!
    @IBOutlet weak var menuGearBackground: UIView!
    
    @IBOutlet weak var btnArchieCard: UIButton!
    @IBOutlet weak var btnRentals: UIButton!
    @IBOutlet weak var btnGifts: UIButton!
    @IBOutlet weak var btnGear: UIButton!
    
    @IBOutlet weak var iconArchieCard: UIImageView!
    @IBOutlet weak var iconRentals: UIImageView!
    @IBOutlet weak var iconGifts: UIImageView!
    @IBOutlet weak var iconGear: UIImageView!
    
    @IBOutlet weak var labelArchieCard: UILabel!
    @IBOutlet weak var labelRentals: UILabel!
    @IBOutlet weak var labelGifts: UILabel!
    @IBOutlet weak var labelGear: UILabel!
    
    
    
    let interactor = ShopsInteractor()
    
    var menuItems = [ShopsMenu]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        didChangeAppTheme()
        
        
        btnArchieCard.setBackgroundColor(color: .lightGray, forState: .highlighted)
         btnRentals.setBackgroundColor(color: .lightGray, forState: .highlighted)
         btnGifts.setBackgroundColor(color: .lightGray, forState: .highlighted)
         btnGear.setBackgroundColor(color: .lightGray, forState: .highlighted)
        
        menuArchieCardBackground.setCardView()
        menuRentalsBackground.setCardView()
        menuGiftsBackground.setCardView()
        menuGearBackground.setCardView()
    }
    
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_SHOPS
    }
    
    override func didChangeAppTheme() {
        let appColor = UIColor.getAppThemeColor()
        
        labelArchieCard.textColor = appColor
        labelGear.textColor = appColor
        labelGifts.textColor = appColor
        labelRentals.textColor = appColor
        
        if AppEngine.sharedInstance.isEvApp(){
            
            shopsBanner.image = UIImage(named: "byke")
            iconArchieCard.image = UIImage(named: "archie_cards")
             iconRentals.image = UIImage(named: "ic_shop_rentals")
             iconGifts.image = UIImage(named: "gifts")
             iconGear.image = UIImage(named: "gear")
        }else{
            shopsBanner.image = UIImage(named: "moto_shop_background")
            iconArchieCard.image = UIImage(named: "moto_shop_archie_cards")
            iconRentals.image = UIImage(named: "moto_shop_rentals")
            iconGifts.image = UIImage(named: "moto_shop_gifts")
            iconGear.image = UIImage(named: "moto_shop_gear")
        }
    }
    
    
    @IBAction func didPressArchieCards(_ sender: Any) {
    }
    
    @IBAction func didPressRentals(_ sender: Any) {
    }
    
    @IBAction func didPressGift(_ sender: Any) {
    }
    
    @IBAction func didPressGear(_ sender: Any) {
    }
}
