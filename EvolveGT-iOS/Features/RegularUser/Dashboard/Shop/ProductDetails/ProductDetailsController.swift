//
//  ProductDetailsController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 24/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

class ProductDetailsController : ETViewController, ProductDetailsDelegate{
    
    
    @IBOutlet weak var productDetailsView: UITableView!
    
    @IBOutlet weak var btnAddToCart: UIButton!
    var productSlug = ""
    var productName = ""
    
    let interactor = ShopsInteractor()
    
    var productDetails = ProductDetails()
    var sections = [ProductDetailSections]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        productDetailsView.dataSource = self
        productDetailsView.delegate = self
        btnAddToCart.isEnabled = false
        
        interactor.viewDelegate = self
        interactor.productDetailsDelegate = self
        interactor.fetchProductDetails(slug: productSlug)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnAddToCart.applyColorTheme()
        productDetailsView.reloadData()
    }
    
    
    override func getScreenTitle() -> String? {
        productName.capitalized
    }
    
    func didFetchProductDetails(productDetails: ProductDetails) {
        productDetails.preselectDefaultVariant()
        self.productDetails = productDetails
        sections = interactor.getProductDetailsSections(details: productDetails)
        productDetailsView.reloadData()
        enableAddToCart(enabled: !productDetails.isOutOfStock)
    }
    func enableAddToCart(enabled : Bool){
        btnAddToCart.isEnabled = enabled
    }
    
    
    @IBAction func didPressAddToCart(_ sender: Any) {
        
        if !AppEngine.sharedInstance.isUserLoggedIn(){
            self.ext.confirmationAlert(title: AlertTitle.loginRequired, message: MessageConstants.loginRequired, btnText: "Login"){
                self.dashboardManager.switchToLoginPage()
                return
            }
        }else{
            interactor.addProductToCart(productDetails: self.productDetails)
        }
    }
}
extension ProductDetailsController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sections[section] == ProductDetailSections.info{
            return 1
        }else if sections[section] == ProductDetailSections.quantity{
            return 1
        }else if sections[section] == ProductDetailSections.outofstock{
            return 1
        }else if sections[section] == ProductDetailSections.variations{
            return productDetails.variations?.count ?? 0
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if sections[indexPath.section] == ProductDetailSections.info{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductInfoCell", for: indexPath) as! ProductInfoCell
            cell.showData(productDetails: productDetails)
            return cell
        }else if sections[indexPath.section] == ProductDetailSections.quantity{
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductQuantityCell.identifier, for: indexPath) as! ProductQuantityCell
            cell.showData(productDetails: productDetails)
            return cell
        }else if sections[indexPath.section] == ProductDetailSections.outofstock{
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductOutOfStockCell.identifier, for: indexPath) as! ProductOutOfStockCell
            return cell
        }else if sections[indexPath.section] == ProductDetailSections.variations{
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductVariantsCell.identifier, for: indexPath) as! ProductVariantsCell
            let productVariation = productDetails.variations![indexPath.row]
            cell.delegate = self
            cell.showData(productVariation: productVariation, indexPath: indexPath)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    
}
extension ProductDetailsController: ProductVariantsCellDelegate{
    func didChangeVariantSelection(indexPath: IndexPath) {
        
        enableAddToCart(enabled: !productDetails.isOutOfStock)
        sections = interactor.getProductDetailsSections(details: self.productDetails)
        productDetailsView.reloadData()
    }
    
    
}
