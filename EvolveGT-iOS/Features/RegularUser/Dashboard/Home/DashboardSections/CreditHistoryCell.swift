//
//  CreditHistoryCell.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 05/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit


protocol CreditHistoryCellDelegate{
    func toggleCreditDetailsView()
}
class CreditHistoryCell: UITableViewCell{
    
    var delegate :CreditHistoryCellDelegate? = nil
    
    @IBOutlet weak var creditRightButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var creditAmount: UILabel!
    
    @IBOutlet weak var postedDate: UILabel!
    
    @IBOutlet weak var creditDescription: UILabel!
    @IBOutlet weak var seeMoreButton: UIButton!
    
    func showData(_ credit: CreditHistory, expanded: Bool){
        
        if expanded == false{
            
            if containerView != nil {
                containerView.removeFromSuperview()
            }
            //plus button
            let image = UIImage(named: "plus_green")
            creditRightButton.setImage(image, for: .normal)
        }else{
            let image = UIImage(named: "minus_green")
            creditRightButton.setImage(image, for: .normal)
            
            creditAmount.text = credit.amount?.formatToAmount()
            postedDate.text = "Posted on: \(credit.postDate?.formattedDate(inputPattern: .FORMAT_API_DATE, outputFormat: .FORMAT_DD_MMM_YYYY) ?? "")"
            creditDescription.text = credit.creditHistoryDescription
        }
            
        
    }
    
    @IBAction func didPressExpandButton(_ sender: Any) {
        delegate?.toggleCreditDetailsView()
    }
    

}
