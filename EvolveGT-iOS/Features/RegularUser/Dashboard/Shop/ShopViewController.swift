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
    
    
    
    var categoryList = [ProductCategory]()
    
    let interactor = ShopsInteractor()
    
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
        
        interactor.viewDelegate = self
        interactor.categoryDelegate = self
        interactor.fetchCategoryList()
    }
    
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_SHOPS
    }
    
    override func didChangeAppTheme() {
        super.didChangeAppTheme()
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
        
        self.ext.pushViewController(storyBoard: "ArchieCard", VCIdentifier: "archieCardVC")
    }
    
    @IBAction func didPressRentals(_ sender: Any) {
        
        if categoryList.count == 0{
            self.ext.showErrorToast(message: ErrorMessages.genericError, handler: nil)
            self.interactor.fetchCategoryList()
        }else{
            let rentalsVC = self.ext.getViewController(storyBoard: "Shop", VCIdentifier: "ShopTabbedVC") as! ShopTabViewController
            
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
    
    @IBAction func didPressGift(_ sender: Any) {
        
          self.ext.pushViewController(storyBoard: "GiftCard", VCIdentifier: "giftCardVC")
        
    }
    
    @IBAction func didPressGear(_ sender: Any) {
        if categoryList.count == 0{
            self.ext.showErrorToast(message: ErrorMessages.genericError, handler: nil)
            self.interactor.fetchCategoryList()
        }else{
            let gearVC = self.ext.getViewController(storyBoard: "Shop", VCIdentifier: "ShopTabbedVC") as! ShopTabViewController
            
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
extension ShopViewController : CategoryViewDelegate{
    func didFetchCategories(categories: [ProductCategory]) {
        categoryList = categories
    }
    
    override func showEmptyPageError(message: String) {
        //bypass full page error
        self.ext.showErrorToast(message: message, handler: nil)
    }
    
}
