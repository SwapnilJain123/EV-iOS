//
//  ProductListController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import XLPagerTabStrip

class ProductListController : ETViewController, IndicatorInfoProvider, BaseViewDelegate{
    
    @IBOutlet weak var productListView: UICollectionView!
    
    
    var category : ProductCategory? = nil
    var source : String = ""
    let interactor = ShopsInteractor()
    
    var productList = [Product]()
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        IndicatorInfo(title: category?.title?.capitalized)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor.viewDelegate = self
        interactor.productListDelegate = self
        
        productListView.delegate = self
        productListView.dataSource = self
        
        interactor.fetchProductList(category: category!, source: source)
    }
    
    override func getScreenTitle() -> String? {
        source
    }
}

extension ProductListController : ProductListDelegate{
    func didFetchProducts(products: [Product]) {
        productList.removeAll()
        productList.append(contentsOf: products)
        productListView.reloadData()
    }
}
extension ProductListController : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.product = productList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let height = CGFloat(150.0)
        var width = (collectionView.frame.size.width/2) - 10
        
        if DeviceType.IS_IPAD{
            width = (collectionView.frame.size.width/3) - 12
        }
        return CGSize(width: width, height:height)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailsVC = self.ext.getViewController(storyBoard: "Shop", VCIdentifier: "ProductDetailsVC") as! ProductDetailsController
        detailsVC.productSlug = productList[indexPath.row].slug ?? ""
        detailsVC.productName = productList[indexPath.row].title ?? ""
        self.ext.pushViewController(viewController: detailsVC)
    }
    
}
