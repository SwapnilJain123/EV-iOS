//
//  ReviewCartController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 27/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
class ReviewCartController : ETViewController{
    @IBOutlet weak var shippingIndicator: ShippingIndicator!
    
    @IBOutlet weak var cartSummaryView: UITableView!
    var interactor : CartInteractor? = nil
    var cartItems : [CartItem]?
    var sections : [CartReviewSections]? = nil
    
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_REVIEW_CART
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartSummaryView.dataSource = self
        customizeShippingIndicator()
        sections = interactor?.getCartReviewSections()
    }
    func customizeShippingIndicator(){
        shippingIndicator.leftCircleColor = .clear
        shippingIndicator.leftCircleBorderColor = .getAppThemeColor()
        shippingIndicator.middleCircleColor = .getInactiveGray()
        shippingIndicator.rightCircleColor = .getInactiveGray()
        
        shippingIndicator.leftLineColor = .getInactiveGray()
        shippingIndicator.rightLineColor = .getInactiveGray()
        shippingIndicator.indicatorViewBackground = UIColor(hexFromString: "#F5F6F7")
        shippingIndicator.redrawView()
    }
}
extension ReviewCartController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sections?.count ?? 0 > 0{
            if sections![section] == CartReviewSections.summaryItems{
                return cartItems?.count ?? 0
            }else{
                return 1
            }
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections![indexPath.section] {
        case CartReviewSections.summaryHeader:
            return tableView.dequeueReusableCell(withIdentifier: "CartSummaryTitle", for: indexPath)
        case CartReviewSections.summaryItems:
            let cell =  tableView.dequeueReusableCell(withIdentifier: CartReviewItemCell.identifier, for: indexPath) as! CartReviewItemCell
            cell.showData(cartItem : cartItems![indexPath.row])
            return cell
        case CartReviewSections.total:
            let cell =  tableView.dequeueReusableCell(withIdentifier: CartTotalCell.identifier, for: indexPath) as! CartTotalCell
            
            let computedTotal = interactor!.computeTotals()
            cell.showData(computedTotal.subTotal, computedTotal.total)
            return cell
        case CartReviewSections.coupon:
            let cell =  tableView.dequeueReusableCell(withIdentifier: CartPromoCodeCell.identifier, for: indexPath) as! CartPromoCodeCell
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections?.count ?? 0
    }
}
